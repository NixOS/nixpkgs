{ lib
, buildPythonPackage
, fetchFromGitHub
, lz4
, numpy
, oauthlib
, pandas
, poetry-core
, pyarrow
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, thrift
}:

buildPythonPackage rec {
  pname = "databricks-sql-connector";
  version = "2.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-XyDkL/bGnivx7MRG86vGS69mKdrWw7kKiuvQfBYFKVQ=";
  };

  pythonRelaxDeps = [
    "numpy"
    "thrift"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    lz4
    numpy
    oauthlib
    pandas
    pyarrow
    thrift
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
