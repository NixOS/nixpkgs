#!/usr/bin/env ruby

require 'json'
require 'nokogiri'
require 'slop'

# Returns a repo URL for a given package name.
def repo_url value
  if value && value.start_with?('http')
    value
  elsif value
    "https://dl.google.com/android/repository/#{value}"
  else
    nil
  end
end

# Returns a system image URL for a given system image name.
def image_url value, dir
  if value && value.start_with?('http')
    value
  elsif value
    "https://dl.google.com/android/repository/sys-img/#{dir}/#{value}"
  else
    nil
  end
end

# Returns a tuple of [type, revision, revision components] for a package node.
def package_revision package
  type_details = package.at_css('> type-details')
  type = type_details.attributes['type']
  type &&= type.value

  revision = nil
  components = nil

  case type
  when 'generic:genericDetailsType', 'addon:extraDetailsType', 'addon:mavenType'
    major = text package.at_css('> revision > major')
    minor = text package.at_css('> revision > minor')
    micro = text package.at_css('> revision > micro')
    preview = text package.at_css('> revision > preview')

    revision = ''
    components = []
    unless empty?(major)
      revision << major
      components << major
    end

    unless empty?(minor)
      revision << ".#{minor}"
      components << minor
    end

    unless empty?(micro)
      revision << ".#{micro}"
      components << micro
    end

    unless empty?(preview)
      revision << "-rc#{preview}"
      components << preview
    end
  when 'sdk:platformDetailsType'
    codename = text type_details.at_css('> codename')
    api_level = text type_details.at_css('> api-level')
    revision = empty?(codename) ? api_level : codename
    components = [revision]
  when 'sdk:sourceDetailsType'
    api_level = text type_details.at_css('> api-level')
    revision, components = api_level, [api_level]
  when 'sys-img:sysImgDetailsType'
    codename = text type_details.at_css('> codename')
    api_level = text type_details.at_css('> api-level')
    id = text type_details.at_css('> tag > id')
    abi = text type_details.at_css('> abi')

    revision = ''
    components = []
    if empty?(codename)
      revision << api_level
      components << api_level
    else
      revision << codename
      components << codename
    end

    unless empty?(id)
      revision << "-#{id}"
      components << id
    end

    unless empty?(abi)
      revision << "-#{abi}"
      components << abi
    end
  when 'addon:addonDetailsType' then
    api_level = text type_details.at_css('> api-level')
    id = text type_details.at_css('> tag > id')
    revision = api_level
    components = [api_level, id]
  end

  [type, revision, components]
end

# Returns a hash of archives for the specified package node.
def package_archives package
  archives = {}
  package.css('> archives > archive').each do |archive|
    host_os = text archive.at_css('> host-os')
    host_os = 'all' if empty?(host_os)
    archives[host_os] = {
      'size' => Integer(text(archive.at_css('> complete > size'))),
      'sha1' => text(archive.at_css('> complete > checksum')),
      'url' => yield(text(archive.at_css('> complete > url')))
    }
  end
  archives
end

# Returns the text from a node, or nil.
def text node
  node ? node.text : nil
end

# Nil or empty helper.
def empty? value
  !value || value.empty?
end

# Fixes up returned hashes by sorting keys.
# Will also convert archives (e.g. {'linux' => {'sha1' => ...}, 'macosx' => ...} to
# [{'os' => 'linux', 'sha1' => ...}, {'os' => 'macosx', ...}, ...].
def fixup value
  Hash[value.map do |k, v|
    if k == 'archives' && v.is_a?(Hash)
      [k, v.map do |os, archive|
        fixup({'os' => os}.merge(archive))
      end]
    elsif v.is_a?(Hash)
      [k, fixup(v)]
    else
      [k, v]
    end
  end.sort {|(k1, v1), (k2, v2)| k1 <=> k2}]
end

# Normalize the specified license text.
# See: https://brash-snapper.glitch.me/ for how the munging works.
def normalize_license license
  license = license.dup
  license.gsub!(/([^\n])\n([^\n])/m, '\1 \2')
  license.gsub!(/ +/, ' ')
  license
end

# Gets all license texts, deduplicating them.
def get_licenses doc
  licenses = {}
  doc.css('license[type="text"]').each do |license_node|
    license_id = license_node['id']
    if license_id
      licenses[license_id] ||= []
      licenses[license_id] |= [normalize_license(text(license_node))]
    end
  end
  licenses
end

def parse_package_xml doc
  licenses = get_licenses doc
  packages = {}

  doc.css('remotePackage').each do |package|
    name, _, version = package['path'].partition(';')
    next if version == 'latest'

    type, revision, _ = package_revision(package)
    next unless revision

    path = package['path'].tr(';', '/')
    display_name = text package.at_css('> display-name')
    uses_license = package.at_css('> uses-license')
    uses_license &&= uses_license['ref']
    archives = package_archives(package) {|url| repo_url url}

    target = (packages[name] ||= {})
    target = (target[revision] ||= {})

    target['name'] ||= name
    target['path'] ||= path
    target['revision'] ||= revision
    target['displayName'] ||= display_name
    target['license'] ||= uses_license if uses_license
    target['archives'] ||= {}
    merge target['archives'], archives
  end

  [licenses, packages]
end

def parse_image_xml doc
  licenses = get_licenses doc
  images = {}

  doc.css('remotePackage[path^="system-images;"]').each do |package|
    type, revision, components = package_revision(package)
    next unless revision

    path = package['path'].tr(';', '/')
    display_name = text package.at_css('> display-name')
    uses_license = package.at_css('> uses-license')
    uses_license &&= uses_license['ref']
    archives = package_archives(package) {|url| image_url url, components[-2]}

    target = images
    components.each do |component|
      target = (target[component] ||= {})
    end

    target['name'] ||= "system-image-#{revision}"
    target['path'] ||= path
    target['revision'] ||= revision
    target['displayName'] ||= display_name
    target['license'] ||= uses_license if uses_license
    target['archives'] ||= {}
    merge target['archives'], archives
  end

  [licenses, images]
end

def parse_addon_xml doc
  licenses = get_licenses doc
  addons, extras = {}, {}

  doc.css('remotePackage').each do |package|
    type, revision, components = package_revision(package)
    next unless revision

    path = package['path'].tr(';', '/')
    display_name = text package.at_css('> display-name')
    uses_license = package.at_css('> uses-license')
    uses_license &&= uses_license['ref']
    archives = package_archives(package) {|url| repo_url url}

    case type
    when 'addon:addonDetailsType'
      name = components.last
      target = addons

      # Hack for Google APIs 25 r1, which displays as 23 for some reason
      archive_name = text package.at_css('> archives > archive > complete > url')
      if archive_name == 'google_apis-25_r1.zip'
        path = 'add-ons/addon-google_apis-google-25'
        revision = '25'
        components = [revision, components.last]
      end
    when 'addon:extraDetailsType', 'addon:mavenType'
      name = package['path'].tr(';', '-')
      components = [package['path']]
      target = extras
    end

    components.each do |component|
      target = (target[component] ||= {})
    end

    target['name'] ||= name
    target['path'] ||= path
    target['revision'] ||= revision
    target['displayName'] ||= display_name
    target['license'] ||= uses_license if uses_license
    target['archives'] ||= {}
    merge target['archives'], archives
  end

  [licenses, addons, extras]
end

def merge dest, src
  dest.merge! src
end

opts = Slop.parse do |o|
  o.array '-p', '--packages', 'packages repo XMLs to parse'
  o.array '-i', '--images', 'system image repo XMLs to parse'
  o.array '-a', '--addons', 'addon repo XMLs to parse'
end

result = {
  licenses: {},
  packages: {},
  images: {},
  addons: {},
  extras: {}
}

opts[:packages].each do |filename|
  licenses, packages = parse_package_xml(Nokogiri::XML(File.open(filename)))
  merge result[:licenses], licenses
  merge result[:packages], packages
end

opts[:images].each do |filename|
  licenses, images = parse_image_xml(Nokogiri::XML(File.open(filename)))
  merge result[:licenses], licenses
  merge result[:images], images
end

opts[:addons].each do |filename|
  licenses, addons, extras = parse_addon_xml(Nokogiri::XML(File.open(filename)))
  merge result[:licenses], licenses
  merge result[:addons], addons
  merge result[:extras], extras
end

puts JSON.pretty_generate(fixup(result))
