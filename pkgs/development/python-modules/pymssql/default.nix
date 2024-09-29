{
  lib,
  buildPythonPackage,
  fetchPypi,
  freetds,
  krb5-c,
  openssl,
  cython,
  gevent,
  psutil,
  pytestCheckHook,
  setuptools-scm,
  sqlalchemy,
  tomli,
}:

buildPythonPackage rec {
  pname = "pymssql";
  version = "2.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3e4VxMGT4UyS/izXIMqb4duh4PQXgkA4C49fbwDaBMY=";
  };

  build-system = [
    cython
    setuptools-scm
    tomli
  ];

  buildInputs = [
    freetds
    krb5-c
    openssl
  ];

  nativeCheckInputs = [
    gevent
    psutil
    pytestCheckHook
    sqlalchemy
  ];

  pythonImportsCheck = [ "pymssql" ];

  meta = with lib; {
    changelog = "https://github.com/pymssql/pymssql/blob/v${version}/ChangeLog.rst";
    description = "Simple database interface for Python that builds on top of FreeTDS to provide a Python DB-API (PEP-249) interface to Microsoft SQL Server";
    homepage = "https://github.com/pymssql/pymssql";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.sith-lord-vader ];
  };
}
