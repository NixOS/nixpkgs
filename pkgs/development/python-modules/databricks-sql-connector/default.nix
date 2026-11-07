{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  alembic,
  lz4,
  numpy,
  oauthlib,
  openpyxl,
  pandas,
  poetry-core,
  pyarrow,
  pybreaker,
  pyjwt,
  pytestCheckHook,
  sqlalchemy,
  thrift,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "databricks-sql-connector";
  version = "4.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    tag = "v${version}";
    hash = "sha256-ostwH82yth1ho8gfWty33NoxU1KipYsMvXf7yHLDauc=";
  };

  pythonRelaxDeps = [
    "pandas"
    "pyarrow"
    "python-dateutil"
    "thrift"
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    alembic
    lz4
    numpy
    oauthlib
    openpyxl
    pandas
    pyarrow
    pybreaker
    pyjwt
    sqlalchemy
    thrift
    requests
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTests = [
    # AssertionError: A fake module is shadowing the native kernel
    "test_async_cursor_refetch_preserves_session"
    "test_async_cursor_reads_overlap_owner_poll"
  ];

  pythonImportsCheck = [ "databricks" ];

  meta = {
    description = "Databricks SQL Connector for Python";
    homepage = "https://docs.databricks.com/dev-tools/python-sql-connector.html";
    changelog = "https://github.com/databricks/databricks-sql-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ harvidsen ];
  };
}
