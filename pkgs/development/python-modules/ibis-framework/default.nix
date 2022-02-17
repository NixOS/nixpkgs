{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, atpublic
, cached-property
, clickhouse-driver
, click
, dask
, graphviz
, importlib-metadata
, multipledispatch
, numpy
, pandas
, parsy
, poetry-core
, pyarrow
, pytest
, pytest-mock
, pytest-xdist
, pytz
, regex
, requests
, sqlalchemy
, tables
, toolz
}:
let
  # ignore tests for which dependencies are not available
  backends = [
    "csv"
    "dask"
    "hdf5"
    "pandas"
    "parquet"
    "sqlite"
  ];

  backendsString = lib.concatStringsSep " " backends;

  ibisTestingData = fetchFromGitHub {
    owner = "ibis-project";
    repo = "testing-data";
    rev = "743201a35c6b968cf55b054f9d28949ea15d1f0a";
    sha256 = "sha256-xuSE6wHP3aF8lnEE2SuFbTRBu49ecRmc1F3HPcszptI=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "2.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "ibis";
    owner = "ibis-project";
    rev = version;
    sha256 = "sha256-n3fR6wvcSfIo7760seB+5SxtoYSqQmqkzZ9VlNQF200=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    atpublic
    cached-property
    clickhouse-driver
    dask
    graphviz
    multipledispatch
    numpy
    pandas
    parsy
    pyarrow
    pytz
    regex
    requests
    sqlalchemy
    tables
    toolz
  ] ++ lib.optionals (pythonOlder "3.8" && lib.versionOlder version "3.0.0") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
    click
    pytest
    pytest-mock
    pytest-xdist
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'atpublic = ">=2.3,<3"' 'atpublic = ">=2.3"'
  '';

  preBuild = ''
    # setup.py exists only for developer convenience and is automatically generated
    rm setup.py
  '';

  disabledTests = [
    # These tests are broken upstream: https://github.com/ibis-project/ibis/issues/3291
    "test_summary_numeric"
    "test_summary_non_numeric"
    "test_batting_most_hits"
    "test_join_with_window_function"
    "test_where_long"
    "test_quantile_groupby"
    "test_summary_numeric"
    "test_summary_numeric_group_by"
    "test_summary_non_numeric"
    "test_searched_case_column"
    "test_simple_case_column"
    "test_summary_non_numeric_group_by"
  ];

  pytestFlagsArray = [
    "--numprocesses $NIX_BUILD_CORES"
    "ibis/tests"
    "ibis/backends/tests"
    "ibis/backends/{${lib.concatStringsSep "," backends}}/tests"
  ];

  preCheck = ''
    set -euo pipefail

    export IBIS_TEST_DATA_DIRECTORY
    IBIS_TEST_DATA_DIRECTORY="$(mktemp -d)"

    # copy the test data to a writable directory
    cp -r ${ibisTestingData}/* "$IBIS_TEST_DATA_DIRECTORY"

    find "$IBIS_TEST_DATA_DIRECTORY" -type d -exec chmod u+rwx {} +
    find "$IBIS_TEST_DATA_DIRECTORY" -type f -exec chmod u+rw {} +

    # load data
    for backend in ${backendsString}; do
      python ci/datamgr.py "$backend" &
    done

    wait
  '' + lib.optionalString (lib.versionOlder version "3.0.0") ''
    export PYTEST_BACKENDS="${backendsString}"
  '';

  pythonImportsCheck = [
    "ibis"
  ] ++ (map (backend: "ibis.backends.${backend}") backends);

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc cpcloud ];
  };
}
