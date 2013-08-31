{ stdenv, fetchurl, pkgconfig, libpng, libtiff, lcms, cmake, glib/*passthru only*/ }:

stdenv.mkDerivation rec {
  name = "openjpeg-2.0.0";
  passthru = {
    incDir = "openjpeg-2.0";
  };

  src = fetchurl {
    url = "http://openjpeg.googlecode.com/files/${name}.tar.gz";
    sha1 = "0af78ab2283b43421458f80373422d8029a9f7a7";
  };

  buildInputs = [ cmake ];
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
