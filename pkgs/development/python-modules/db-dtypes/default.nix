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
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-OAVHx/a4uupVGXSWN2/3uem9/4i+TUkzTX4kp0uLY44=";
  };

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  nativeCheckInputs = [
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
