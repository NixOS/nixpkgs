{ lib
, buildPythonPackage
, fetchPypi
, numpy
, packaging
, pandas
, pyarrow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3070d1a8d86ff0b5d9b16f15c5fab9c18893c6b3d5723cd95ee397b169049454";
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
