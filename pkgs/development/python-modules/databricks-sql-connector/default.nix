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
  version = "2.0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "databricks";
    repo = "databricks-sql-python";
    rev = "v${version}";
    sha256 = "sha256-Qpdyn6z1mbO4bzyUZ2eYdd9pfIkIP/Aj4YgNXaYwxpE=";
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

  checkInputs = [
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
