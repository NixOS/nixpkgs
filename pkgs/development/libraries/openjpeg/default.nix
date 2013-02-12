{ stdenv, fetchurl, pkgconfig, libpng, libtiff, lcms2 }:

stdenv.mkDerivation rec {
  name = "openjpeg-1.5.1";

  src = fetchurl {
    url = "http://openjpeg.googlecode.com/files/${name}.tar.gz";
    sha256 = "13dbyf3jwr4h2dn1k11zph3jgx17z7d66xmi640mbsf8l6bk1yvc";
  };

  buildInputs = [ pkgconfig libpng libtiff lcms2 ];

  meta = {
    homepage = http://www.openjpeg.org/;
    description = "Open-source JPEG 2000 codec written in C language";
    license = "BSD";
    platforms = stdenv.lib.platforms.all;
  };
}
