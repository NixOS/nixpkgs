{
  lib,
  buildPythonPackage,
  fetchPypi,
  freetds,
  krb5,
  openssl,
  cython,
  setuptools-scm,
  sqlparse,
  tomli
}:

buildPythonPackage rec {
  pname = "pymssql";
  version = "2.3.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8DTka1aAYdFxSPHe3qZI+dX2tzQOjP/g7bqhcTy0q6s=";
  };

  build-system = [
    setuptools-scm
    tomli
    cython
  ];

  buildInputs = [
    krb5
    openssl
    freetds
  ];

  propagatedBuildInputs = [
    sqlparse
  ];

  pythonImportsCheck = [
    "pymssql"
  ];

  meta = with lib; {
    description = "A simple database interface for Python that builds on top of FreeTDS to provide a Python DB-API (PEP-249) interface to Microsoft SQL Server.";
    homepage = "https://github.com/pymssql/pymssql";
    license = licenses.lgpl21;
    maintainers = [ maintainers.sith-lord-vader ];
  };
}
