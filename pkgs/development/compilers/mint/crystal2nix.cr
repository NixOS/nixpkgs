require "yaml"

File.open "shards.nix", "w+" do |file|
  file.puts "{"
  yaml = YAML.parse(File.read("shard.lock"))
  yaml["shards"].each do |key, value|
    file.puts "  #{key} = {"
    file.puts %(    url = "https://github.com/#{value["github"]}";)
    if value["commit"]?
      file.puts %(    rev = "#{value["commit"]}";)
    else
      url = "https://github.com/#{value["github"]}"
      ref = "v#{value["version"]}"

      puts "git ls-remote #{url} #{ref}"
      Process.run("git", args: ["ls-remote", url, ref]) do |x|
        x.error.each_line { |e| puts e }
        x.output.each_line { |o| value.as_h["commit"] = o.split("\t")[0] }
      end

      file.puts %(    rev = "#{value["commit"]};)
    end

    file.puts "  };"
  end
  file.puts "}"
end
