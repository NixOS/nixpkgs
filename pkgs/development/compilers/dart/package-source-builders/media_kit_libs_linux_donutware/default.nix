{
  stdenv,
  fetchurl,
  lib,
  writeScript,
  libpulseaudio,
  libGL,
  libx11,
  libgbm,
}:

{ version, src, ... }:

let
  mimalloc = fetchurl {
    url = "https://github.com/microsoft/mimalloc/archive/refs/tags/v2.1.2.tar.gz";
    hash = "sha256-Kxv/b3F/lyXHC/jXnkeG2hPeiicAWeS6C90mKue+Rus=";
  };
in
stdenv.mkDerivation {
  pname = "media_kit_libs_linux";
  inherit version src;
  inherit (src) passthru;

  setupHook = writeScript "media-kit-libs-linux-setup-hook" ''
    mediaKitLibsLinuxFixupHook() {
      runtimeDependencies+=('${lib.getLib libpulseaudio}')
      runtimeDependencies+=('${lib.getLib libGL}')
      runtimeDependencies+=('${lib.getLib libx11}')
      runtimeDependencies+=('${lib.getLib libgbm}')
    }
    preFixupHooks+=(mediaKitLibsLinuxFixupHook)
  '';

  postPatch = ''
    sed -i '/download_and_verify(/,/)/{
      /download_and_verify(/c\  execute_process(COMMAND ''${CMAKE_COMMAND} -E copy ${mimalloc} ''${MIMALLOC_ARCHIVE})
      /MIMALLOC_URL/d
      /MIMALLOC_MD5/d
      /MIMALLOC_ARCHIVE/d
      /^  )$/d
    }' libs/linux/media_kit_libs_linux/linux/CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r ./* $out/
    runHook postInstall
  '';
}
