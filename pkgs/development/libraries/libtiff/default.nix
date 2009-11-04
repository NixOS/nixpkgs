{ stdenv, fetchurl, zlib, libjpeg }:

stdenv.mkDerivation {
  name = "libtiff-3.9.1";
  
  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.9.1.tar.gz;
    sha256 = "168yssav47xih2y17m7psj4k6ngnfai300bbfznc75hn3crxfdil";
  };
  
  propagatedBuildInputs = [zlib libjpeg];

  meta = {
    description = "Library and utilities for working with the TIFF image file format";
    homepage = http://www.libtiff.org/;
    license = "bsd";
  };
}
