{ stdenv, lib, buildPythonPackage, fetchFromGitHub
, sqlite
, cython
, apsw
, flask
, withPostgres ? false, psycopg2
, withMysql ? false, mysql-connector
}:

buildPythonPackage rec {

  pname = "peewee";
  version = "3.9.3";

  # pypi release does not provide tests
  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = version;
    sha256 = "1frwwqkk0y1bkcm7bdzbyv2119vv640ncgs4d55zhbs70fxm2ylj";
  };


  checkInputs = [ flask ];

  checkPhase = ''
    rm -r playhouse # avoid using the folder in the cwd
    python runtests.py
  '';

  buildInputs = [
    sqlite
    cython # compile speedups
  ];

  propagatedBuildInputs = [
    apsw # sqlite performance improvement
  ] ++ (lib.optional withPostgres psycopg2)
    ++ (lib.optional withMysql mysql-connector);

  meta = with stdenv.lib;{
    description = "a small, expressive orm";
    homepage    = http://peewee-orm.com;
    license     = licenses.mit;
  };
}
