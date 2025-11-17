{
  lib,
  buildPythonPackage,
  click,
  configobj,
  fetchPypi,
  postgresql,
  postgresqlTestHook,
  psycopg,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  sqlparse,
  stdenv,
}:

buildPythonPackage rec {
  pname = "pgspecial";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2mx/zHvve7ATLcIEb3TsZROx/m8MgOVSjWMNFLfEhJ0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    click
    sqlparse
    psycopg
  ];

  # postgresqlTestHook is not available on Darwin
  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = [
    configobj
    pytestCheckHook
    postgresqlTestHook
    postgresql
  ];

  pytestFlagsArray = [ "-vvv" ];

  env = {
    PGDATABASE = "_test_db";
    PGUSER = "postgres";
  };

  disabledTests = [
    "test_slash_d_view_verbose"
    "test_slash_ddp"
    "test_slash_ddp_pattern"
  ];

  meta = with lib; {
    description = "Meta-commands handler for Postgres Database";
    homepage = "https://github.com/dbcli/pgspecial";
    changelog = "https://github.com/dbcli/pgspecial/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ lib.maintainers.SuperSandro2000 ];
  };
}
