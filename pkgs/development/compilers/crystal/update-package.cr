#!/usr/bin/env nix-shell
#! nix-shell -p cacert crystal crystal2nix shards nix-prefetch-github -i crystal

require "json"
require "http/client"
require "file_utils"

class Updater
  class Release
    JSON.mapping({
      tag_name: String,
      prerelease: Bool,
      published_at: Time,
    })
  end

  class Prefetch
    JSON.mapping({ sha256: String })
  end

  API_URL = "https://api.github.com"
  RAW_URL = "https://raw.githubusercontent.com"
  HEADERS = HTTP::Headers{ "Accept" => "application/vnd.github.v3+json" }

  getter owner : String, repo : String

  def initialize(@owner, @repo); end

  # use APIv3 because v4 requires a token
  def releases
    url = API_URL + "/repos/#{owner}/#{repo}/releases"

    HTTP::Client.get(url, HEADERS) do |response|
      Array(Release).from_json(response.body_io)
    end
  end

  def last_release
    releases.reject(&.prerelease).max_by do |release|
      release.published_at
    end
  end

  def update!
    release = last_release
    unless release
      STDERR.puts "Couldn't find latest release"
      exit 1
    end

    clean
    update_lock(release.tag_name)
    crystal2nix
    update_nix(release.tag_name)
    clean

  rescue ex
    STDERR.puts ex.inspect
    exit 1
  end

  def update_lock(tag)
    url = RAW_URL + "/#{owner}/#{repo}/#{tag}/shard.lock"
    puts url

    HTTP::Client.get(url) do |response|
      case response.status
      when HTTP::Status::OK
        File.open("shard.lock", "w") do |fd|
          IO.copy(response.body_io, fd)
        end
      when HTTP::Status::NOT_FOUND
        update_lock_from_yml(tag)
      else
        raise "Unknown response: #{response.status_code}"
      end
    end
  end

  def update_lock_from_yml(tag)
    url = RAW_URL + "/#{owner}/#{repo}/#{tag}/shard.yml"
    puts url

    HTTP::Client.get(url) do |response|
      File.open("shard.yml", "w") do |fd|
        IO.copy(response.body_io, fd)
      end
    end

    system("shards", ["lock"])
  end

  def crystal2nix
    system("crystal2nix")
  end

  def update_nix(tag)
    md = tag.match(/v(.*)/)
    return unless md

    version = md[1]
    hash = prefetch(tag).sha256

    updated = File.read("default.nix")
      .gsub(/version = "[^"]+";/){ %(version = "#{version}";) }
      .gsub(/sha256 = "[^"]+";/){ %(sha256 = "#{hash}";) }

    File.write("default.nix", updated)
  end

  def prefetch(tag)
    args = ["--prefetch", "--rev", tag, owner, repo]
    Process.run("nix-prefetch-github", args) do |process|
      process.error.each_line do |line|
        STDERR.puts line
      end
      Prefetch.from_json(process.output)
    end
  end

  def clean
    %w[ shard.lock shard.yml ].each do |path|
      FileUtils.rm_rf path
    end
  end
end

owner = ARGV[0]?
repo = ARGV[1]?

unless owner && repo
  STDERR.puts "usage: update-crystal-package owner repo"
  exit 1
end

Updater.new(owner, repo).update!
