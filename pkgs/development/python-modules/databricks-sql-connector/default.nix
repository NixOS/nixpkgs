{ lib
, buildPythonPackage
, fetchFromGitHub
, alembic
, lz4
, numpy
, oauthlib
, openpyxl
, pandas
, poetry-core
, pyarrow
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, sqlalchemy
, thrift
}:

buildPythonPackage rec {
  pname = "databricks-sql-connector";
  version = "2.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-V8Nl6xr96Xnd1gkw9R0aqXkitLESsAyW7ufTYn6ttLg=";
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
    alembic
    lz4
    numpy
    oauthlib
    openpyxl
    pandas
    pyarrow
    sqlalchemy
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
    # No SQLAlchemy 2.0 support
    # https://github.com/databricks/databricks-sql-python/issues/91
    broken = true;
  };
}
