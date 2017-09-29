{ stdenv, fetchurl, libkate, pango, cairo, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libtiger-0.3.4";

  src = fetchurl {
    url = "http://libtiger.googlecode.com/files/${name}.tar.gz";
    sha256 = "0rj1bmr9kngrgbxrjbn4f4f9pww0wmf6viflinq7ava7zdav4hkk";
  };

  buildInputs = [ libkate pango cairo pkgconfig ];

  meta = {
    homepage = http://code.google.com/p/libtiger/;
    description = "A rendering library for Kate streams using Pango and Cairo";
    platforms = stdenv.lib.platforms.unix;
  };
}
