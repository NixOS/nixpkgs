{ stdenv, fetchurl, fetchpatch, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.7";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz";
    sha256 = "06ghqhr4db1ssq0acyyz49gr8k41gzw6pqb6mbn5r7jqp77s4hwz";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ zlib libjpeg xz ]; #TODO: opengl support (bogus configure detection)

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://download.osgeo.org/libtiff;
    license = licenses.libtiff;
    platforms = platforms.unix;
  };
}
