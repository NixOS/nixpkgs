{stdenv, fetchurl, zlib, libjpeg}:

assert zlib != null && libjpeg != null;

stdenv.mkDerivation {
  name = "libtiff-3.7.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/tiff-3.7.1.tar.gz;
    md5 = "37d222df12eb23691614cd40b7b1f215";
  };
  propagatedBuildInputs = [zlib libjpeg];
  inherit zlib libjpeg;
}
