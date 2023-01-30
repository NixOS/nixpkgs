{ lib
, buildPythonPackage
, fetchFromGitHub
, thrift
, pandas
, pyarrow
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "databricks-sql-connector";
  version = "2.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-EMLUXGeVGIXFeaMvaJ+crivRZtOt7W/LCycIO2gwqXA=";
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

  pytestFlagsArray = [ "tests/unit" ];

  meta = with lib; {
    description = "Databricks SQL Connector for Python";
    homepage = "https://docs.databricks.com/dev-tools/python-sql-connector.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ harvidsen ];
  };
}
