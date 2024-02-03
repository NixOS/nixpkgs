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
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peewee";
  version = "3.16.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QeJaGTKZHmzN+J8uUGXQJXCTINX7iP30u+s+GDP/kpQ=";
  };

  buildInputs = [
    sqlite
    cython
  ];

  propagatedBuildInputs = [
    apsw
  ] ++ lib.optionals withPostgres [
    psycopg2
  ] ++ lib.optionals withMysql [
    mysql-connector
  ];

  nativeCheckInputs = [
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
