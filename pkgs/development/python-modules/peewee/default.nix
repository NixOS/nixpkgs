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
  version = "3.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-2rxGOUCITEHuM83qhaKQGK4jSf4r8hcBAGxRImT/rhE=";
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
