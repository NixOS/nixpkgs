{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  packaging,
  pandas,
  pyarrow,
  pytest8_3CheckHook,
  pythonAtLeast,
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

  # https://github.com/googleapis/python-db-dtypes-pandas/pull/379
  postPatch = lib.optionalString (pythonAtLeast "3.14") ''
    substituteInPlace tests/unit/test_date.py \
      --replace-fail '"year 10000 is out of range"' '"year must be in 1..9999, not 10000"' \
      --replace-fail '"day is out of range for month"' '"day 99 must be in range 1..28 for month 2 in year 2021"'
  '';

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

  meta = {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    changelog = "https://github.com/googleapis/python-db-dtypes-pandas/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
