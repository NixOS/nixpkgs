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
  version = "3.8.1";

  # pypi release does not provide tests
  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = version;
    sha256 = "0z6fdihmvqfg0ysa94g4w2w7146fsi2gnrgh90b4i1s3wj8iaxqy";
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
