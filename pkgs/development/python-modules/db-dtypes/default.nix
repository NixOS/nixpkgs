{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, packaging
, pandas
, pyarrow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-RlSze0e2NNHJ6kAbj9TX58MaEPutyjcLXIOYjpugO6o=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "db_dtypes"
  ];

  meta = with lib; {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    changelog = "https://github.com/googleapis/python-db-dtypes-pandas/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
