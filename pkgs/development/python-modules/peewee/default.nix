{ lib
, apsw
, buildPythonPackage
, cython
, fetchFromGitHub
, flask
, python
, sqlite
, withMysql ? false
, mysql-connector
, withPostgres ? false
, psycopg2
}:

buildPythonPackage rec {
  pname = "peewee";
  version = "3.14.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = version;
    sha256 = "sha256-8rwWKsOOYUrk2k1piCurb1LkB9zzmSITq52qWdyx4yk=";
  };

  buildInputs = [
    sqlite
    cython
  ];

  propagatedBuildInputs = [
    apsw
  ] ++ lib.optional withPostgres psycopg2
  ++ lib.optional withMysql mysql-connector;

  checkInputs = [
    flask
  ];

  doCheck = withPostgres;

  checkPhase = ''
    rm -r playhouse # avoid using the folder in the cwd
    ${python.interpreter} runtests.py
  '';

  pythonImportsCheck = [
    "peewee"
  ];

  meta = with lib; {
    description = "Python ORM with support for various database implementation";
    homepage = "http://peewee-orm.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
