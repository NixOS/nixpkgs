{stdenv, fetchurl}: derivation {
  name = "db4-4.2.52";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.sleepycat.com/update/snapshot/db-4.2.52.tar.gz;
    md5 = "cbc77517c9278cdb47613ce8cb55779f";
  };
  stdenv = stdenv;
}
