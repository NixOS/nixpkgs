{stdenv, fetchurl, zlib, libjpeg}:

assert zlib != null && libjpeg != null;

stdenv.mkDerivation {
  name = "libtiff-3.5.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.remotesensing.org/pub/libtiff/tiff-v3.5.7.tar.gz;
    md5 = "82243b5ae9b7c9e492aeebc501680990";
  };
  propagatedBuildInputs = [zlib libjpeg];
  inherit zlib libjpeg;
}
