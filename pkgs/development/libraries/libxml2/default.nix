{stdenv, fetchurl, zlib}:

assert zlib != null;

derivation {
  name = "libxml2-2.6.7";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/libxml2-2.6.7.tar.bz2;
    md5 = "bdbef92cbdc5b4bd0365313ba22b75ce";
  };
  stdenv = stdenv;
  zlib = zlib;
}
