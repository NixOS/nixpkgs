{ lib
, buildPythonPackage
, fetchFromGitHub
, thrift
, pandas
, pyarrow
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "databricks-sql-connector";
  version = "2.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-EMLUXGeVGIXFeaMvaJ+crivRZtOt7W/LCycIO2gwqXA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'thrift = "^0.13.0"' 'thrift = ">=0.13.0,<1.0.0"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    thrift
    pandas
    pyarrow
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  pythonImportsCheck = [
    "databricks"
  ];

  meta = with lib; {
    description = "Databricks SQL Connector for Python";
    homepage = "https://docs.databricks.com/dev-tools/python-sql-connector.html";
    changelog = "https://github.com/databricks/databricks-sql-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ harvidsen ];
  };
}
