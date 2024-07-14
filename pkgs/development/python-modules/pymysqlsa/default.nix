{
  lib,
  buildPythonPackage,
  fetchPypi,
  pymysql,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pymysql-sa";
  version = "1.0";

  src = fetchPypi {
    inherit version;
    pname = "pymysql_sa";
    hash = "sha256-omdrzlFKKbLWq0GIEiWbDC91ZBUKxTRVQgogvXk1MUo=";
  };

  propagatedBuildInputs = [
    pymysql
    sqlalchemy
  ];

  meta = with lib; {
    description = "PyMySQL dialect for SQL Alchemy";
    homepage = "https://pypi.python.org/pypi/pymysql_sa";
    license = licenses.mit;
  };
}
