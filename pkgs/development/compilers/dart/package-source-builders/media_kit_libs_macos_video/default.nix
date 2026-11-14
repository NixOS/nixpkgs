{ stdenvNoCC }:

{ version, src, ... }:

stdenvNoCC.mkDerivation {
  pname = "media_kit_libs_macos_video";
  inherit version src;
  inherit (src) passthru;
  dontBuild = true;
  postPatch = ''
    # The Dart and video plugin adapters use Nixpkgs' libmpv directly.
    substituteInPlace '${src.passthru.packageRoot}/macos/media_kit_libs_macos_video.podspec' \
      --replace-fail 'system("make")' ""
    sed -i '/s.vendored_frameworks/d' \
      '${src.passthru.packageRoot}/macos/media_kit_libs_macos_video.podspec'
  '';
  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    runHook postInstall
  '';
}
