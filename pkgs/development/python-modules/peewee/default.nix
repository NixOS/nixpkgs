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
  version = "3.14.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = version;
    sha256 = "sha256-BJSM+7+VdW6SxN4/AXsX8NhQPdIFoYrVRVwR9OsJ3QE=";
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
