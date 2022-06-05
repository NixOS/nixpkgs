{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, packaging
, pandas
, pyarrow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "v${version}";
    hash = "sha256-T/cyJ0PY5p/y8CKrmeAa9nvnuRs4hd2UKiYiMHLaa7A=";
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

  pythonImportsCheck = [ "db_dtypes" ];

  meta = with lib; {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
