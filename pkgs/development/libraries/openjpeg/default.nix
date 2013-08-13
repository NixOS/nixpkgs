{ stdenv, fetchurl, pkgconfig, libpng, libtiff, lcms, glib/*passthru only*/ }:

stdenv.mkDerivation rec {
  name = "openjpeg-1.5.1";
  passthru = {
    incDir = "openjpeg-1.5";
  };

  src = fetchurl {
    url = "http://openjpeg.googlecode.com/files/${name}.tar.gz";
    sha256 = "13dbyf3jwr4h2dn1k11zph3jgx17z7d66xmi640mbsf8l6bk1yvc";
  };

  nativebuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libpng libtiff lcms ]; # in closure anyway

  postInstall = glib.flattenInclude;

  meta = {
    homepage = http://www.openjpeg.org/;
    description = "Open-source JPEG 2000 codec written in C language";
    license = "BSD";
    platforms = stdenv.lib.platforms.all;
  };
}
