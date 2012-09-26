{ stdenv, fetchurl, zlib, libjpeg }:

let version = "3.9.7"; in

stdenv.mkDerivation rec {
  name = "libtiff-${version}";

  src = fetchurl {
    urls =
      [ "ftp://ftp.remotesensing.org/pub/libtiff/tiff-${version}.tar.gz"
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz"
      ];
    sha256 = "0spg1hr5rsrmg88sfzb05qnf0haspq7r5hvdkxg5zib1rva4vmpm";
  };

  propagatedBuildInputs = [ zlib libjpeg ];

  enableParallelBuilding = true;

  meta = {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.libtiff.org/;
    license = "bsd";
  };
}
