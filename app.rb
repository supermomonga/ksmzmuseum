# coding: utf-8

require 'bundler'
Bundler.require

# Event CG shown at IdolProduce.
# idol_{idol_id}_{stage_id}_{diff_id}.png
# e.g. http://125.6.169.35/idolmaster/image_sp/event_flash/410/idol/idol_26_1_1.png


def save_image idol_id, stage_id, diff_id
  # sleep 0.1
  Dir.mkdir('images') unless Dir.exist? 'images'
  idol_id = "%02d" % idol_id
  file_name = "idol_#{idol_id}_#{stage_id}_#{diff_id}.png"
  url = "http://125.6.169.35/idolmaster/image_sp/event_flash/410/idol/#{file_name}"
  file_path = "./images/#{file_name}"

  # Exit if the file is already exist and isn't broken
  if File.exist? file_path
    if FileTest.size? file_path
      return true
    else
      File.delete file_path
    end
  end


  puts url
  res = Net::HTTP.get_response URI.parse(url)
  case res
  when Net::HTTPSuccess
    File.open(file_path, 'wb') do |io|
      io.puts res.body
    end
    true
  else
    false
  end
end

stage_num = 3
diff_num = 7
1.upto(Float::INFINITY) do |idol_id|
  if save_image idol_id, 3, 1
    [*1..stage_num].product [*1..diff_num] do |(stage_id, diff_id)|
      save_image idol_id, stage_id, diff_id
    end
  else
    break
  end
end

