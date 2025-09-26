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
  pytestCheckHook,
  pythonOlder,
  sqlalchemy,
  thrift,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "databricks-sql-connector";
  version = "4.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    tag = "v${version}";
    hash = "sha256-CzS6aVOFkBSJ9+0KJOaJLxK2ZiRY4OybNkCX5VdybqY=";
  };

  pythonRelaxDeps = [
    "pandas"
    "pyarrow"
    "thrift"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    alembic
    lz4
    numpy
    oauthlib
    openpyxl
    pandas
    pyarrow
    sqlalchemy
    thrift
    requests
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "databricks" ];

  meta = with lib; {
    description = "Databricks SQL Connector for Python";
    homepage = "https://docs.databricks.com/dev-tools/python-sql-connector.html";
    changelog = "https://github.com/databricks/databricks-sql-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ harvidsen ];
  };
}
