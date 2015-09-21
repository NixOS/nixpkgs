{ stdenv, fetchurl, pkgconfig, zlib, libjpeg, xz }:

let
  version = "4.0.5";
in
stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    urls =
      [ "ftp://ftp.remotesensing.org/pub/libtiff/tiff-${version}.tar.gz"
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz"
      ];
    sha256 = "171hgy4mylwmvdm7gp6ffjva81m4j56v3fbqsbfl7avzxn1slpp2";
  };

  outputs = [ "out" "doc" "man" ];

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
