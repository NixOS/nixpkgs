{ stdenv, fetchurl, zlib, libjpeg }:

stdenv.mkDerivation {
  name = "libtiff-3.9.4";
  
  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.9.4.tar.gz;
    sha256 = "19hxd773yxcs4lxlc3zfdkz5aiv705vj2jvy5srpqkxpbw3nvdv7";
  };
  
  propagatedBuildInputs = [ zlib libjpeg ];

  meta = {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.libtiff.org/;
    license = "bsd";
  };
}
