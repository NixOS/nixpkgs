{stdenv, fetchurl, zlib}:

assert zlib != null;

stdenv.mkDerivation {
  name = "libxml2-2.6.7";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/libxml2-2.6.7.tar.bz2;
    md5 = "bdbef92cbdc5b4bd0365313ba22b75ce";
  };
  zlib = zlib;
}
