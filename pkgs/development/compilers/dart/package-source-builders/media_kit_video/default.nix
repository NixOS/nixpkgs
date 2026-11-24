{
  lib,
  stdenvNoCC,
  mpv-unwrapped,
}:

{ version, src, ... }:

stdenvNoCC.mkDerivation {
  pname = "media_kit_video";
  inherit version src;
  inherit (src) passthru;
  dontBuild = true;

  postPatch = ''
    pushd '${src.passthru.packageRoot}/macos'
    mkdir -p Headers/mpv
    cp ${lib.getDev mpv-unwrapped}/include/mpv/*.h Headers/mpv/
    find -L Classes/plugin -name '*.swift' \
      -exec sed -i '1i import Cocoa\nimport CoreVideo\nimport OpenGL' {} +
    # Keep the upstream plugin sources, but use Nixpkgs' headers and library.
    cat > media_kit_video.podspec <<'EOF_PODSPEC'
    Pod::Spec.new do |s|
      s.name = 'media_kit_video'
      s.version = '0.0.1'
      s.summary = 'Native video implementation for media_kit'
      s.homepage = 'https://github.com/media-kit/media-kit'
      s.license = { :file => '../LICENSE' }
      s.author = 'media_kit contributors'
      s.source = { :path => '.' }
      s.platform = :osx, '10.15'
      s.swift_version = '5.0'
      s.dependency 'FlutterMacOS'
      s.source_files = 'Classes/plugin/**/*.swift', 'Headers/**/*.h'
      s.frameworks = 'Cocoa', 'CoreVideo', 'OpenGL'
      s.pod_target_xcconfig = {
        'DEFINES_MODULE' => 'YES',
        'OTHER_LDFLAGS' => '$(inherited) ${lib.getLib mpv-unwrapped}/lib/libmpv.dylib'
      }
    end
    EOF_PODSPEC
    popd
  '';

  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';
}
