{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.8";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libpng-1.2.8.tar.bz2;
    md5 = "00cea4539bea4bd34cbf8b82ff9589cd";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
