{stdenv, fetchurl, zlib}:

assert !isNull zlib;

derivation {
  name = "libxml2-2.6.5";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://rpmfind.net/pub/libxml/libxml2-2.6.5.tar.gz;
    md5 = "0ac5dd9902c9bf20f7bc50de1034d49f";
  };
  stdenv = stdenv;
  zlib = zlib;
}
