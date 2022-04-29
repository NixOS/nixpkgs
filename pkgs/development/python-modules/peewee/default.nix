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
  version = "3.14.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = version;
    hash = "sha256-k3kKAImE1aVlmsSPXpaIkAVspAsAo5Hz6/n7u6+zTzA=";
  };

  buildInputs = [
    sqlite
    cython
  ];

  propagatedBuildInputs = [
    apsw
  ] ++ lib.optional withPostgres [
    psycopg2
  ] ++ lib.optional withMysql [
    mysql-connector
  ];

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
