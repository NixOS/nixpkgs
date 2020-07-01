{ stdenv
, fetchurl

, pkgconfig

, zlib
, libjpeg
, xz
}:

stdenv.mkDerivation rec {
  version = "4.1.0";
  pname = "libtiff";

  src = fetchurl {
    url = "https://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "0d46bdvxdiv59lxnb0xz9ywm8arsr6xsapi5s6y6vnys2wjz6aax";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true; # not cross;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = "http://download.osgeo.org/libtiff";
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
