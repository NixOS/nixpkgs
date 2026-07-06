#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p "ruby.withPackages (ps: with ps; [ slop curb nokogiri ])"

require 'json'
require 'digest'
require 'rubygems'
require 'shellwords'
require 'erb'
require 'uri'
require 'stringio'
require 'slop'
require 'curb'
require 'nokogiri'

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
  if dir == "default"
    dir = "android"
  end
  if value && value.start_with?('http')
    value
  elsif value
    "https://dl.google.com/android/repository/sys-img/#{dir}/#{value}"
  else
    nil
  end
end

# Runs a GET with curl.
def _curl_get url
  curl = Curl::Easy.new(url) do |http|
    http.headers['User-Agent'] = 'nixpkgs androidenv update bot'
    yield http if block_given?
  end
  STDERR.print "GET #{url}"
  curl.perform
  STDERR.puts "... #{curl.response_code}"

  StringIO.new(curl.body_str)
end

# Retrieves a repo from the filesystem or a URL.
def get location
  uri = URI.parse(location)
  case uri.scheme
  when 'repo'
    _curl_get repo_url("#{uri.host}#{uri.fragment}.xml")
  when 'image'
    _curl_get image_url("sys-img#{uri.fragment}.xml", uri.host)
  else
    if File.exist?(uri.path)
      File.open(uri.path, 'rt')
    else
      raise "Repository #{uri} was neither a file nor a repo URL"
    end
  end
end

# Returns a JSON with the data and structure of the input XML
def to_json_collector doc
  json = {}
  index = 0
  doc.element_children.each { |node|
    if node.children.length == 1 and node.children.first.text?
      json["#{node.name}:#{index}"] ||= node.content
      index += 1
      next
    end
    json["#{node.name}:#{index}"] ||= to_json_collector node
    index += 1
  }
  element_attributes = {}
  doc.attribute_nodes.each do |attr|
    if attr.name == "type"
      type = attr.value.split(':', 2).last
      case attr.value
      when 'generic:genericDetailsType'
        element_attributes["xsi:type"] ||= "ns5:#{type}"
      when 'addon:extraDetailsType'
        element_attributes["xsi:type"] ||= "ns8:#{type}"
      when 'addon:mavenType'
        element_attributes["xsi:type"] ||= "ns8:#{type}"
      when 'sdk:platformDetailsType'
        element_attributes["xsi:type"] ||= "ns11:#{type}"
      when 'sdk:sourceDetailsType'
        element_attributes["xsi:type"] ||= "ns11:#{type}"
      when 'sys-img:sysImgDetailsType'
        element_attributes["xsi:type"] ||= "ns12:#{type}"
      when 'addon:addonDetailsType' then
        element_attributes["xsi:type"] ||= "ns8:#{type}"
      end
    else
      element_attributes[attr.name] ||= attr.value
    end
  end
  if !element_attributes.empty?
    json['element-attributes'] ||= element_attributes
  end
  json
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
    host_arch = text archive.at_css('> host-arch')
    host_os = 'all' if empty?(host_os)
    host_arch = 'all' if empty?(host_arch)
    archives[host_os + host_arch] = {
      'os' => host_os,
      'arch' => host_arch,
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

# Fixes up returned hashes by converting archives like
#  (e.g. {'linux' => {'sha1' => ...}, 'macosx' => ...} to
# [{'os' => 'linux', 'sha1' => ...}, {'os' => 'macosx', ...}, ...].
def fixup value
  Hash[value.map do |k, v|
    if k == 'archives' && v.is_a?(Hash)
      [k, v.map do |os, archive|
        fixup(archive)
      end]
    elsif v.is_a?(Hash)
      [k, fixup(v)]
    else
      [k, v]
    end
  end]
end

# Today since Unix Epoch, January 1, 1970.
def today
  Time.now.utc.to_i / 24 / 60 / 60
end

# The expiration strategy. Expire if the last available day was before the `oldest_valid_day`.
def expire_records record, oldest_valid_day
  if record.is_a?(Hash)
    if record.has_key?('last-available-day') &&
      record['last-available-day'] < oldest_valid_day
      return nil
    end
    update = {}
    # This should only happen in the first run of this scrip after adding the `expire_record` function.
    if record.has_key?('displayName') &&
      !record.has_key?('last-available-day')
      update['last-available-day'] = today
    end
    record.each {|key, value|
      v = expire_records value, oldest_valid_day
      update[key] = v if v
    }
    update
  else
    record
  end
end

# Normalize the specified license text.
# See: https://brash-snapper.glitch.me/ for how the munging works.
def normalize_license license
  license = license.dup
  license.gsub!(/([^\n])\n([^\n])/m, '\1 \2')
  license.gsub!(/ +/, ' ')
  license.strip!
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
  # check https://github.com/NixOS/nixpkgs/issues/373785
  extras = {}

  doc.css('remotePackage').each do |package|
    name, _, version = package['path'].partition(';')
    next if version == 'latest'

    is_extras = name == 'extras'
    if is_extras
      name = package['path'].tr(';', '-')
    end

    type, revision, _ = package_revision(package)
    next unless revision

    path = package['path'].tr(';', '/')
    display_name = text package.at_css('> display-name')
    uses_license = package.at_css('> uses-license')
    uses_license &&= uses_license['ref']
    obsolete ||= package['obsolete']
    type_details = to_json_collector package.at_css('> type-details')
    revision_details = to_json_collector package.at_css('> revision')
    archives = package_archives(package) {|url| repo_url url}
    dependencies_xml = package.at_css('> dependencies')
    dependencies = to_json_collector dependencies_xml if dependencies_xml

    if is_extras
      target = extras
      component = package['path']
      target = (target[component] ||= {})
    else
      target = (packages[name] ||= {})
      target = (target[revision] ||= {})
    end

    target['name'] ||= name
    target['path'] ||= path
    target['revision'] ||= revision
    target['displayName'] ||= display_name
    target['license'] ||= uses_license if uses_license
    target['obsolete'] ||= obsolete if obsolete == 'true'
    target['type-details'] ||= type_details
    target['revision-details'] ||= revision_details
    target['dependencies'] ||= dependencies if dependencies
    target['archives'] ||= {}
    merge target['archives'], archives
    target['last-available-day'] = today
  end

  [licenses, packages, extras]
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
    obsolete &&= package['obsolete']
    type_details = to_json_collector package.at_css('> type-details')
    revision_details = to_json_collector package.at_css('> revision')
    archives = package_archives(package) {|url| image_url url, components[-2]}
    dependencies_xml = package.at_css('> dependencies')
    dependencies = to_json_collector dependencies_xml if dependencies_xml

    target = images
    components.each do |component|
      target[component] ||= {}
      target = target[component]
    end

    target['name'] ||= "system-image-#{revision}"
    target['path'] ||= path
    target['revision'] ||= revision
    target['displayName'] ||= display_name
    target['license'] ||= uses_license if uses_license
    target['obsolete'] ||= obsolete if obsolete
    target['type-details'] ||= type_details
    target['revision-details'] ||= revision_details
    target['dependencies'] ||= dependencies if dependencies
    target['archives'] ||= {}
    merge target['archives'], archives
    target['last-available-day'] = today
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
    obsolete &&= package['obsolete']
    type_details = to_json_collector package.at_css('> type-details')
    revision_details = to_json_collector package.at_css('> revision')
    archives = package_archives(package) {|url| repo_url url}
    dependencies_xml = package.at_css('> dependencies')
    dependencies = to_json_collector dependencies_xml if dependencies_xml

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
    target['obsolete'] ||= obsolete if obsolete
    target['type-details'] ||= type_details
    target['revision-details'] ||= revision_details
    target['dependencies'] ||= dependencies if dependencies
    target['archives'] ||= {}
    merge target['archives'], archives
    target['last-available-day'] = today
  end

  [licenses, addons, extras]
end

# Make the clean diff by always sorting the result before puting it in the stdout.
def sort_recursively value
  if value.is_a?(Hash)
    Hash[
      value.map do |k, v|
        [k, sort_recursively(v)]
      end.sort_by {|(k, v)| k }
    ]
  elsif value.is_a?(Array)
    value.map do |v| sort_recursively(v) end
  else
    value
  end
end

def merge_recursively a, b
  a.merge!(b) {|key, a_item, b_item|
    if a_item.is_a?(Hash) && b_item.is_a?(Hash)
      merge_recursively(a_item, b_item)
    elsif b_item != nil
      b_item
    end
  }
  a
end

def merge dest, src
  merge_recursively dest, src
end

opts = Slop.parse do |o|
  o.array '-p', '--packages', 'packages repo XMLs to parse', default: %w[repo://repository#2-3]
  o.array '-i', '--images', 'system image repo XMLs to parse', default: %w[
    image://android#2-3
    image://android-tv#2-3
    image://android-wear#2-3
    image://android-wear-cn#2-3
    image://android-automotive#2-3
    image://google_apis#2-3
    image://google_apis_playstore#2-3
  ]
  o.array '-a', '--addons', 'addon repo XMLs to parse', default: %w[repo://addon#2-3]
  o.string '-I', '--input', 'input JSON file for repo', default: File.join(__dir__, 'repo.json')
  o.string '-O', '--output', 'output JSON file for repo', default: File.join(__dir__, 'repo.json')
end

result = {}
result['licenses'] = {}
result['packages'] = {}
result['images'] = {}
result['addons'] = {}
result['extras'] = {}

opts[:packages].each do |filename|
  licenses, packages, extras = parse_package_xml(Nokogiri::XML(get(filename)) { |conf| conf.noblanks })
  merge result['licenses'], licenses
  merge result['packages'], packages
  merge result['extras'], extras
end

opts[:images].each do |filename|
  licenses, images = parse_image_xml(Nokogiri::XML(get(filename)) { |conf| conf.noblanks })
  merge result['licenses'], licenses
  merge result['images'], images
end

opts[:addons].each do |filename|
  licenses, addons, extras = parse_addon_xml(Nokogiri::XML(get(filename)) { |conf| conf.noblanks })
  merge result['licenses'], licenses
  merge result['addons'], addons
  merge result['extras'], extras
end

result['latest'] = {}
result['packages'].each do |name, versions|
  max_version = Gem::Version.new('0')
  versions.each do |version, package|
    if package['license'] == 'android-sdk-license' && Gem::Version.correct?(package['revision'])
      package_version = Gem::Version.new(package['revision'])
      max_version = package_version if package_version > max_version
    end
  end
  result['latest'][name] = max_version.to_s
end

# As we keep the old packages in the repo JSON file, we should have
# a strategy to remove them at some point!
# So with this variable we claim it's okay to remove them from the
# JSON after two years that they are not available.
two_years_ago = today - 2 * 365

input = {}
prev_latest = {}
begin
  input_json = if File.exist?(opts[:input])
                 STDERR.puts "Reading #{opts[:input]}"
                 File.read(opts[:input])
               else
                 STDERR.puts "Creating new repo"
                 "{}"
               end

  if input_json != nil && !input_json.empty?
    input = expire_records(JSON.parse(input_json), two_years_ago)

    # Just create a new set of latest packages.
    prev_latest = input['latest'] || {}
    input['latest'] = {}
  end
rescue JSON::ParserError => e
  STDERR.write(e.message)
  return
end

fixup_result = fixup(result)

# Regular installation of Android SDK would keep the previously installed packages even if they are not
# in the uptodate XML files, so here we try to support this logic by keeping un-available packages,
# therefore the old packages will work as long as the links are working on the Google servers.
output = sort_recursively(merge(input, fixup_result))

# Fingerprint the latest versions.
fingerprint = Digest::SHA256.hexdigest(output['latest'].tap {_1.delete 'fingerprint'}.to_json)[0...16]
output['latest']['fingerprint'] = fingerprint

# Write the repository. Append a \n to keep nixpkgs Github Actions happy.
STDERR.puts "Writing #{opts[:output]}"
File.write opts[:output], (JSON.pretty_generate(output) + "\n")

# Output metadata for the nixpkgs update script.
if ENV['UPDATE_NIX_ATTR_PATH']
  # See if there are any changes in the latest versions.
  cur_latest = output['latest'] || {}

  old_versions = []
  new_versions = []
  changes = []
  changed = false

  cur_latest.each do |k, v|
    prev = prev_latest[k]
    if k != 'fingerprint' && prev && prev != v
      old_versions << "#{k}:#{prev}"
      new_versions << "#{k}:#{v}"
      changes << "#{k}: #{prev} -> #{v}"
      changed = true
    end
  end

  changed_paths = []
  if changed
    # Instantiate it.
    test_result = `NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ACCEPT_ANDROID_SDK_LICENSE=1 nix-build #{Shellwords.escape(File.realpath(File.join(__dir__, '..', '..', '..', '..', 'default.nix')))} -A #{Shellwords.join [ENV['UPDATE_NIX_ATTR_PATH']]} 2>&1`
    test_status = $?.exitstatus

    template = ERB.new(<<-EOF, trim_mode: '<>-')
androidenv: <%= changes.join('; ') %>

Performed the following automatic androidenv updates:

<% changes.each do |change| %>
- <%= change -%>
<% end %>

Tests exited with status: <%= test_status -%>

<% if !test_result.empty? %>
Last 100 lines of output:
```
<%= test_result.lines.last(100).join -%>
```
<% end %>
EOF

    changed_paths << {
      attrPath: 'androidenv.androidPkgs.androidsdk',
      oldVersion: old_versions.join('; '),
      newVersion: new_versions.join('; '),
      files: [
        opts[:output]
      ],
      commitMessage: template.result(binding)
    }
  end

  # nix-update info is on stdout
  STDOUT.puts JSON.pretty_generate(changed_paths)
end
