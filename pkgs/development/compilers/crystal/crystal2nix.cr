require "yaml"
require "json"

class PrefetchJSON
  JSON.mapping(sha256: String)
end

class ShardLock
  YAML.mapping(
    version: Float32,
    shards: Hash(String, Hash(String, String))
  )
end

File.open "shards.nix", "w+" do |file|
  file.puts %({)
  yaml = ShardLock.from_yaml(File.read("shard.lock"))
  yaml.shards.each do |key, value|
    owner, repo = value["github"].split("/")
    url = "https://github.com/#{value["github"]}"
    rev = if value["version"]?
            "v#{value["version"]}"
          else
            value["commit"]
          end

    sha256 = ""
    args = ["--url", url, "--rev", rev]
    Process.run("@nixPrefetchGit@", args: args) do |x|
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
