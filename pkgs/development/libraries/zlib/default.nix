{stdenv, fetchurl}: derivation {
  name = "zlib-1.1.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.gzip.org/zlib/zlib-1.1.4.tar.gz;
    md5 = "abc405d0bdd3ee22782d7aa20e440f08";
  };
  stdenv = stdenv;
}
