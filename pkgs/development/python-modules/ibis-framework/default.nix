{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
, atpublic
, cached-property
, click
, clickhouse-cityhash
, clickhouse-driver
, dask
, datafusion
, duckdb
, duckdb-engine
, geoalchemy2
, geopandas
, graphviz-nox
, importlib-metadata
, lz4
, multipledispatch
, numpy
, packaging
, pandas
, parsy
, poetry-core
, poetry-dynamic-versioning
, psycopg2
, pyarrow
, pydantic
, pymysql
, pyspark
, pytest-benchmark
, pytest-randomly
, pytest-mock
, pytest-xdist
, python
, pytz
, regex
, shapely
, sqlalchemy
, sqlite
, tabulate
, toolz
}:
let
  testBackends = [
    "dask"
    "datafusion"
    "duckdb"
    "pandas"
    "sqlite"
  ];

  ibisTestingData = fetchFromGitHub {
    owner = "ibis-project";
    repo = "testing-data";
    rev = "a88a4b3c3b54a88e7f77e59de70f5bf20fb62f19";
    sha256 = "sha256-BnRhVwPcWFwiBJ2ySgiiuUdnF4gesnTq1/dLcuvc868=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "3.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "ibis";
    owner = "ibis-project";
    rev = version;
    hash = "sha256-7ywDMAHQAl39kiHfxVkq7voUEKqbb9Zq8qlaug7+ukI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ibis-project/ibis/commit/a6f64c6c32b49098d39bb205952cbce4bdfea657.patch";
      sha256 = "sha256-puVMjiJXWk8C9yhuXPD9HKrgUBYcYmUPacQz5YO5xYQ=";
      includes = [ "pyproject.toml" ];
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    atpublic
    cached-property
    importlib-metadata
    multipledispatch
    numpy
    packaging
    pandas
    parsy
    poetry-dynamic-versioning
    pydantic
    pytz
    regex
    tabulate
    toolz
  ];

  checkInputs = [
    pytestCheckHook
    click
    pytest-benchmark
    pytest-mock
    pytest-randomly
    pytest-xdist
  ] ++ lib.concatMap (name: passthru.optional-dependencies.${name}) testBackends;

  preBuild = ''
    # setup.py exists only for developer convenience and is automatically generated
    rm setup.py
  '';

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
  ];

  preCheck = ''
    set -eo pipefail

    export IBIS_TEST_DATA_DIRECTORY
    IBIS_TEST_DATA_DIRECTORY="$(mktemp -d)"

    # copy the test data to a writable directory
    cp -r ${ibisTestingData}/* "$IBIS_TEST_DATA_DIRECTORY"

    find "$IBIS_TEST_DATA_DIRECTORY" -type d -exec chmod u+rwx {} +
    find "$IBIS_TEST_DATA_DIRECTORY" -type f -exec chmod u+rw {} +

    # load data
    for backend in ${lib.concatStringsSep " " testBackends}; do
      ${python.interpreter} ci/datamgr.py load "$backend"
    done
  '';

  postCheck = ''
    rm -r "$IBIS_TEST_DATA_DIRECTORY"
  '';

  pythonImportsCheck = [
    "ibis"
  ] ++ map (backend: "ibis.backends.${backend}") testBackends;

  passthru = {
    optional-dependencies = {
      clickhouse = [ clickhouse-cityhash clickhouse-driver lz4 ];
      dask = [ dask pyarrow ];
      datafusion = [ datafusion ];
      duckdb = [ duckdb duckdb-engine sqlalchemy ];
      geospatial = [ geoalchemy2 geopandas shapely ];
      mysql = [ pymysql sqlalchemy ];
      pandas = [ ];
      postgres = [ psycopg2 sqlalchemy ];
      pyspark = [ pyarrow pyspark ];
      sqlite = [ sqlalchemy sqlite ];
      visualization = [ graphviz-nox ];
    };
  };

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc cpcloud ];
  };
}
