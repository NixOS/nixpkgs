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
  version = "3.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    tag = "v${version}";
    hash = "sha256-drtMkES3eHo1LfUICwxsIwfVc1qA0+0ZWm5W+Av81Z8=";
  };

  pythonRelaxDeps = [
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

  pytestFlagsArray = [ "tests/unit" ];

  pythonImportsCheck = [ "databricks" ];

  meta = with lib; {
    description = "Databricks SQL Connector for Python";
    homepage = "https://docs.databricks.com/dev-tools/python-sql-connector.html";
    changelog = "https://github.com/databricks/databricks-sql-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ harvidsen ];
  };
}
