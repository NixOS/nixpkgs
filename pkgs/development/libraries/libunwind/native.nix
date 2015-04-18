{ stdenv }:

assert stdenv.isDarwin;

stdenv.mkDerivation {
  name = "libunwind-native";

  unpackPhase = ":";
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib
    cat /usr/lib/system/libunwind.dylib > $out/lib/libunwind.dylib
  '';

  meta.platforms = stdenv.lib.platforms.darwin;
}
