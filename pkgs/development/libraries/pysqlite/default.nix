{stdenv, fetchurl, python, sqlite}:

stdenv.mkDerivation {
  name = "pysqlite-2.2.2";
  src = fetchurl {
    url = http://initd.org/pub/software/pysqlite/releases/2.2/2.2.2/pysqlite-2.2.2.tar.gz;
    md5 = "3260547d3f11c85613b2de8ed529a4fc";
  };
  builder = ./builder.sh;

  inherit stdenv python sqlite;
}
