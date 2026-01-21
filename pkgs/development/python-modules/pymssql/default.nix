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
  version = "2.3.11";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R+5x2cN4gN2CuDClp/xpN00ElFwnBDEWtMaThYxgr2Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=54.0,<70.3" "setuptools>=54.0"
  '';

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

  meta = {
    changelog = "https://github.com/pymssql/pymssql/blob/v${version}/ChangeLog.rst";
    description = "Simple database interface for Python that builds on top of FreeTDS to provide a Python DB-API (PEP-249) interface to Microsoft SQL Server";
    homepage = "https://github.com/pymssql/pymssql";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.sith-lord-vader ];
  };
}
