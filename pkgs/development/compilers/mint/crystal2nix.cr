require "yaml"
require "json"

class PrefetchJSON
  JSON.mapping(sha256: String)
end

File.open "shards.nix", "w+" do |file|
  file.puts %({)
  yaml = YAML.parse(File.read("shard.lock"))
  yaml["shards"].each do |key, value|
    owner, repo = value["github"].as_s.split("/")
    url = "https://github.com/#{value["github"]}"
    rev = if value["version"]?
            "v#{value["version"]}"
          else
            value["commit"].as_s
          end

    sha256 = ""
    args = ["--url", url, "--rev", rev]
    Process.run("nix-prefetch-git", args: args) do |x|
      x.error.each_line { |e| puts e }
      sha256 = PrefetchJSON.from_json(x.output).sha256
    end

    file.puts %(  #{key} = {)
    file.puts %(    owner = "#{owner}";)
    file.puts %(    repo = "#{repo}";)
    file.puts %(    rev = "#{rev}";)
    file.puts %(    sha256 = "#{sha256}";)
    file.puts %(  };)
  end
  file.puts %(})
end
