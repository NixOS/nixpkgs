{stdenv, fetchurl}: derivation {
  name = "a52dec-0.7.4";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz;
    md5 = "caa9f5bc44232dc8aeea773fea56be80";
  };
  stdenv = stdenv;
}
