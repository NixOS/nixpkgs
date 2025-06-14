#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p ruby ruby.gems.nokogiri

require 'net/http'
require 'nokogiri'

PACKAGE = 'zlibrary-desktop'

def log(...) = $stderr.puts(...)
def finish(...) = log(...) || exit

def archive url
  log "Archiving #{url} on Wayback Machine..."

  req = Net::HTTP::Get.new URI "https://web.archive.org/save/#{url}"
  res = Net::HTTP.start req.uri.host, req.uri.port, use_ssl: true do |http|
    http.open_timeout = 30
    http.read_timeout = 300 # sometimes WM is very slow
    http.request req
  end

  location = res['Content-Location']
  return "https://web.archive.org#{location}" if location&.start_with? '/web/'

  redirect = res['Location']
  return redirect if redirect&.include? '/web/'

  res_url = res.uri.to_s
  return res_url if res_url&.include? '/web/'
end

def url_hash url
  prefetch_hash = `nix-prefetch-url --unpack #{url}`.strip
  `nix --extra-experimental-features nix-command hash convert --hash-algo sha256 #{prefetch_hash}`.strip
end

def n(attribute) = `nix-instantiate --eval --strict --attr #{PACKAGE}.#{attribute}`.strip.undump

nix_file = n('meta.position')[/(.*):\d+$/, 1]
current_version = n 'version'
current_hash = n 'src.drvAttrs.outputHash'
current_url = n 'src.drvAttrs.urls.0'
current_homepage = n 'meta.homepage'
nix = File.read nix_file

wikipedia = Nokogiri::HTML Net::HTTP.get URI 'https://en.wikipedia.org/wiki/Z-Library'
url = wikipedia.at_css('.infobox th.infobox-label:contains("URL") + td.infobox-data a[href^="https://"]')&.[] 'href'
abort 'Could not find Z-Library URL on Wikipedia page.' unless url
abort "Could not update homepage #{current_homepage} -> #{url}" unless nix.sub! current_homepage, url
log "Z-Library URL: #{url}"

page = Nokogiri::HTML Net::HTTP.get URI url
unless page.at_css 'head link[rel="stylesheet"][href*="zaccess.css"]'
  page = Nokogiri::HTML Net::HTTP.get URI URI.join url, 'z-access'
end

item = page.at_css '.za-download-link-title:has(> .za-download-link-title-name:contains("Linux"))'
abort 'Could not find Linux download link on Z-Library page.' unless item

version = item.at_css('.za-download-link-title-version')&.text[/\d+\.\d+\.\d+/]
abort 'Could not find version number in Linux download link.' unless version
log "Version: #{version}"
finish 'Version is up to date.' if version == current_version
abort "Could not update version: #{current_version} -> #{version}" unless nix.sub! current_version, version

download = item.at_css('a.za-download-href-link[href$=".tar.gz"]')&.[] 'href'
abort 'Could not find download link for Linux version.' unless download
log "Download link: #{download}"

archive_url = archive download
abort 'Could not archive download link.' unless archive_url
abort "Could not update URL: #{current_url} -> #{archive_url}" unless nix.sub! current_url, archive_url
log "Archived download link: #{archive_url}"

hash = url_hash download
abort "Could not update hash: #{current_hash} -> #{hash}" unless nix.sub! current_hash, hash
log "Updated hash: #{hash}"

File.write nix_file, nix
