require 'socket'

X = "\e[31m"
Y = "\e[0m"

hostname = "#{X}#{ENV['USER']}#{Y}@#{X}#{Socket.gethostname}#{Y}"
gsub_hostname = hostname.gsub(/\e\[[\d;]*m/, '')
separator = "-" * gsub_hostname.length

shell = `ps -p #{Process.ppid} -o comm=`.strip

total_sec = File.read('/proc/uptime').split[0].to_i
hours = total_sec / 3600
mins  = (total_sec % 3600) / 60

info = [
  hostname,
  separator,
  "#{X} OS     -> #{Y}#{`lsb_release -sd`.strip.delete('"')}",
  "#{X}󰇄 Host   -> #{Y}#{File.read('/sys/devices/virtual/dmi/id/product_name').strip}",
  "#{X} Kernel -> #{Y}#{`uname -r`.strip}",
  "#{X} Uptime -> #{Y}#{hours} hours, #{mins} mins",
  "#{X} Shell  -> #{Y}#{shell}",
  "#{X} Ruby   -> #{Y}#{RUBY_VERSION}"
]

ascii = [
  "#{X}         XXX.+X$$$$    #{Y}",
  "#{X}      $$$XXXX..$$$$$   #{Y}",
  "#{X}    $$$$$$$XXXXXX$$$   #{Y}",
  "#{X}  x$$$$$$$$$$$$$$$$$   #{Y}",
  "#{X} $$$$$$$$$.:X$$$$$$$   #{Y}",
  "#{X} X$$$$$$;xxxx$$$$$$$   #{Y}",
  "#{X}:+xX$$ $$$$$$$$$$$$    #{Y}",
  "#{X}X+::;;$$$$$$$$$$$$$    #{Y}",
  "#{X}$$xxxX$$$$$$$$$$$$X    #{Y}",
  "#{X}$$$X$$$$$$$$$XXXX$$    #{Y}",
  "#{X} $$$$$$$$$$$$$$$$      #{Y}"
]

top_padding = [(ascii.size - info.size) / 2, 0].max
centered_info = Array.new(top_padding, "") + info

ascii_width = ascii.map { |l| l.gsub(/\e\[[\d;]*m/, '').length }.max + 4
lines = [ascii.size, info.size].max

lines.times do |i|
  left  = ascii[i] || ""
  right = centered_info[i] || ""
  puts left.ljust(ascii_width) + right
end

