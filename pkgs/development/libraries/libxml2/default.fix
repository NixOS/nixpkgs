{stdenv, fetchurl, zlib}:

assert !isNull zlib;

derivation {
  name = "libxml2-2.6.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://rpmfind.net/pub/libxml/libxml2-2.6.2.tar.gz;
    md5 = "56e7f74d3d44cc16790ad08624faef64";
  };
  stdenv = stdenv;
  zlib = zlib;
}
