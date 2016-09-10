{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "libb64-${version}";
  version = "1.2";

  src = fetchurl {
    url = "http://download.draios.com/dependencies/libb64-1.2.src.zip";
    sha256 = "1lxzi6v10qsl2r6633dx0zwqyvy0j19nmwclfd0d7qybqmhqsg9l";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out $out/lib $out/bin $out/include
    cp -r include/* $out/include/
    cp base64/base64 $out/bin/
    cp src/libb64.a src/cencode.o src/cdecode.o $out/lib/
  '';

  meta = {
    inherit version;
    description = "ANSI C routines for fast base64 encoding/decoding";
    license = stdenv.lib.licenses.publicDomain;
    platforms = stdenv.lib.platforms.unix;
  };
}
