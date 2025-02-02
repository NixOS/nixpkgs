{
  stdenv,
}:

# Implementation notes

# The patch exploits the fact that the download part is enclosed with "# ---"
# To use this module you will need to pass the CMake variable MIMALLOC_LIB
# example: -DMIMALLOC_LIB=${pkgs.mimalloc}/lib/mimalloc.o

# Direct link for the original CMakeLists.txt: https://raw.githubusercontent.com/media-kit/media-kit/main/libs/linux/media_kit_libs_linux/linux/CMakeLists.txt

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "media_kit_libs_linux";
  inherit version src;
  inherit (src) passthru;

  doBuild = false;

  postPatch = ''
    awk -i inplace 'BEGIN {opened = 0}; /# --*[^$]*/ { print (opened ? "]===]" : "#[===["); opened = !opened }; {print $0}' linux/CMakeLists.txt
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r ./* "$out"

    runHook postInstall
  '';
}
