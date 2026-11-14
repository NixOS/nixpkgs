# Preserve the project's dependency manager configuration. Native libraries are
# supplied by Nix; CocoaPods and SwiftPM integrate the plugins into Xcode.
require 'json'
require 'open3'
require 'fileutils'
require 'tempfile'
require 'xcodeproj'

module NixFlutterMacOS
  def self.clamp_deployment_targets(project, minimum)
    [project, *project.targets].each do |target|
      target.build_configurations.each do |config|
        current = config.build_settings['MACOSX_DEPLOYMENT_TARGET']
        next unless current.to_s.match?(/\A\d+(\.\d+)*\z/)
        if Gem::Version.new(current) < Gem::Version.new(minimum)
          config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = minimum
        end
      end
    end
    project.save
  end
end

if $PROGRAM_NAME == __FILE__
  nix_minimum = ARGV.fetch(0)
  sdk, status = Open3.capture2('xcrun', '--sdk', 'macosx', '--show-sdk-path')
  abort 'Could not locate the macOS SDK' unless status.success?
  settings = JSON.parse(File.read(File.join(sdk.strip, 'SDKSettings.json')))
  sdk_minimum = settings.fetch('SupportedTargets').fetch('macosx').fetch('MinimumDeploymentTarget')
  minimum = [nix_minimum, sdk_minimum].max_by { |version| Gem::Version.new(version) }
  swift_packages = JSON.parse(File.read(ENV.fetch('NIX_FLUTTER_SWIFT_PACKAGES')))
  Dir.glob('macos/**/*.xcodeproj').each do |path|
    project = Xcodeproj::Project.open(path)
    project.root_object.package_references.to_a.each do |reference|
      next unless reference.isa == 'XCRemoteSwiftPackageReference'
      local_path = swift_packages[reference.repositoryURL]
      next unless local_path
      replacement = project.new(Xcodeproj::Project::Object::XCLocalSwiftPackageReference)
      replacement.relative_path = local_path
      project.root_object.package_references << replacement
      project.objects.grep(Xcodeproj::Project::Object::XCSwiftPackageProductDependency).each do |product|
        product.package = nil if product.package == reference
      end
      reference.remove_from_project
    end
    NixFlutterMacOS.clamp_deployment_targets(project, minimum)
  end

  exit unless ARGV[1] == '--podfile'
  podfile = File.join(Dir.pwd, 'Podfile')
  abort 'CocoaPods install requested without a Podfile' unless File.exist?(podfile)
  original = File.binread(podfile)
  exit if original.include?('# nixpkgs Flutter CocoaPods setup')

  # Use an empty local spec repository instead of contacting the default CDN.
  # Native dependencies of supported plugins have already been supplied by Nix.
  root = File.join(ENV.fetch('NIX_BUILD_TOP'), 'flutter-cocoapods')
  repo = File.join(root, 'specs')
  FileUtils.mkdir_p(repo)
  abort 'Could not initialize the local CocoaPods repository' unless system('git', 'init', '--quiet', repo)

  # Some shared Darwin podspecs refer to Flutter as well as FlutterMacOS.
  # This supplies metadata only, matching Flutter's own engine placeholder.
  placeholder = File.join(root, 'Flutter')
  FileUtils.mkdir_p(placeholder)
  File.write(File.join(placeholder, 'Flutter.podspec.json'), JSON.generate({
    name: 'Flutter', version: '1.0.0', summary: 'Flutter engine placeholder',
    homepage: 'https://flutter.dev', license: {type: 'BSD'},
    authors: {'Flutter Dev Team' => 'flutter-dev@googlegroups.com'},
    source: {path: '.'}, platforms: {osx: minimum},
    vendored_frameworks: 'path/to/nothing'
  }))

  # Preserve existing Podfile declarations and hooks. Atomically replace files
  # that may have been copied with read-only permissions from the Flutter SDK.
  Tempfile.create(['.Podfile', '.nix'], File.dirname(podfile)) do |file|
    native_pods = ENV.fetch('NIX_FLUTTER_COCOAPODS', '').split(':').map { |entry| entry.split('=', 2) }.to_h
    native_pods['Flutter'] = placeholder
    registrations = native_pods.map { |name, path| "pod #{name.dump}, :path => #{path.dump}" }.join("\n")
    file.write("# nixpkgs Flutter CocoaPods setup\nsource #{"file://#{repo}".dump}\n#{original}\n#{registrations}\n")
    file.write <<~RUBY
      require #{__FILE__.dump}
      target_definitions.each_value do |target|
        platform = target.platform
        if platform && platform.name == :osx && Gem::Version.new(platform.deployment_target || '0') < Gem::Version.new(#{minimum.dump})
          target.set_platform(:osx, #{minimum.dump})
        end
      end
      nix_original_post_install = method(:post_install!)
      define_singleton_method(:post_install!) do |installer|
        nix_original_post_install.call(installer)
        projects = [installer.pods_project, *installer.aggregate_targets.map(&:user_project)]
        projects.concat(installer.generated_projects) if installer.respond_to?(:generated_projects)
        projects.compact.uniq.each do |project|
          NixFlutterMacOS.clamp_deployment_targets(project, #{minimum.dump})
        end
      end
    RUBY
    file.flush
    File.rename(file.path, podfile)
  end
end
