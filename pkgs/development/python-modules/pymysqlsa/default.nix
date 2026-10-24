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
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "pymysql_sa";
    hash = "sha256-omdrzlFKKbLWq0GIEiWbDC91ZBUKxTRVQgogvXk1MUo=";
  };

  propagatedBuildInputs = [
    pymysql
    sqlalchemy
  ];

  meta = {
    description = "PyMySQL dialect for SQL Alchemy";
    homepage = "https://pypi.org/project/pymysql_sa/";
    license = lib.licenses.mit;
  };
}
