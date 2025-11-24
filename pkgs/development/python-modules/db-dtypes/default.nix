{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  pandas,
  pyarrow,
  pytest8_3CheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    tag = "v${version}";
    hash = "sha256-Aq/2yDyvUpLsGr+mmBDQpC9X1pWLpDtYD6qql2sgGNw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  nativeCheckInputs = [ pytest8_3CheckHook ];

  disabledTests = [
    # ValueError: Unable to avoid copy while creating an array as requested.
    "test_array_interface_copy"
    # Failed: DID NOT RAISE <class 'TypeError'>
    "test_reduce_series_numeric"
  ];

  pythonImportsCheck = [ "db_dtypes" ];

  meta = with lib; {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    changelog = "https://github.com/googleapis/python-db-dtypes-pandas/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
