{
  stdenv,
  fetchurl,
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
