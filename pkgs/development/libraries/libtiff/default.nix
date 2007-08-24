{stdenv, fetchurl, zlib, libjpeg}:

assert zlib != null && libjpeg != null;

stdenv.mkDerivation {
  name = "libtiff-3.8.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.8.2.tar.gz;
    md5 = "fbb6f446ea4ed18955e2714934e5b698";
  };
  propagatedBuildInputs = [zlib libjpeg];
  inherit zlib libjpeg;
}
