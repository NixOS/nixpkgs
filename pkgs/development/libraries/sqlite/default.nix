{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sqlite-2.8.17";

  src = fetchurl {
    url = http://www.sqlite.org/sqlite-2.8.17.tar.gz;
    md5 = "838dbac20b56d2c4292e98848505a05b";
  };
}
