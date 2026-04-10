{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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

buildPythonPackage (finalAttrs: {
  pname = "pymssql";
  version = "2.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymssql";
    repo = "pymssql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UOb1gULAg5mNPiOiqcGpZ0Ux3f2Kz204gQ3Xn8fJFfA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"standard-distutils ; python_version>='"'"'3.12'"'"'"' ""
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
    changelog = "https://github.com/pymssql/pymssql/blob/${finalAttrs.src.tag}/ChangeLog.rst";
    description = "Simple database interface for Python that builds on top of FreeTDS to provide a Python DB-API (PEP-249) interface to Microsoft SQL Server";
    homepage = "https://github.com/pymssql/pymssql";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.sith-lord-vader ];
  };
})
