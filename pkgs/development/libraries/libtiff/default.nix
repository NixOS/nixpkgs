{stdenv, fetchurl, zlib, libjpeg}:

assert zlib != null && libjpeg != null;

stdenv.mkDerivation {
  name = "libtiff-3.6.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/libtiff/tiff-v3.6.1.tar.gz;
    md5 = "b3f0ee7617593c2703755672fb1bfed3";
  };
  propagatedBuildInputs = [zlib libjpeg];
  inherit zlib libjpeg;
}
