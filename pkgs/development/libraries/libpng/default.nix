{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libpng-1.2.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libpng-1.2.7.tar.bz2;
    md5 = "21030102f99f81c37276403e5956d198";
  };
  propagatedBuildInputs = [zlib];
  inherit zlib;
}
