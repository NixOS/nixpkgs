{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.6";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    urls =
      [ "ftp://ftp.remotesensing.org/pub/libtiff/tiff-${version}.tar.gz"
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz"
      ];
    sha256 = "136nf1rj9dp5jgv1p7z4dk0xy3wki1w0vfjbk82f645m0w4samsd";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.remotesensing.org/libtiff/;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
