{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, packaging
, pandas
, pyarrow
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "refs/tags/v${version}";
    hash = "sha256-FVRqh30mYVfC8zuhPteuvqGYGTp3PW+pi1bquUjYFAg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    maintainers = with maintainers; [ ];
  };
}
