{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
, atpublic
, click
, clickhouse-cityhash
, clickhouse-driver
, dask
, datafusion
, duckdb
, duckdb-engine
, filelock
, geoalchemy2
, geopandas
, graphviz-nox
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
, rich
, rsync
, shapely
, sqlalchemy
, sqlglot
, sqlite
, toolz
}:
let
  testBackends = [
    "datafusion"
    "duckdb"
    "pandas"
    "sqlite"
  ];

  ibisTestingData = fetchFromGitHub {
    owner = "ibis-project";
    repo = "testing-data";
    rev = "3c39abfdb4b284140ff481e8f9fbb128b35f157a";
    sha256 = "sha256-BZWi4kEumZemQeYoAtlUSw922p+R6opSWp/bmX0DjAo=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "3.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "ibis";
    owner = "ibis-project";
    rev = version;
    hash = "sha256-YRP1nGJs4btqXQirm0GfEDKNPCVXexVrwQ6sE8JtD2o=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    atpublic
    multipledispatch
    numpy
    packaging
    pandas
    parsy
    poetry-dynamic-versioning
    pydantic
    pytz
    regex
    rich
    toolz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    click
    filelock
    pytest-benchmark
    pytest-mock
    pytest-randomly
    pytest-xdist
    rsync
  ] ++ lib.concatMap (name: passthru.optional-dependencies.${name}) testBackends;

  preBuild = ''
    # setup.py exists only for developer convenience and is automatically generated
    # it gets in the way in nixpkgs so we remove it
    rm setup.py
  '';

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
    # this test fails on nixpkgs datafusion version (0.4.0), but works on
    # datafusion 0.6.0
    "-k"
    "'not datafusion-no_op'"
  ];

  preCheck = ''
    set -eo pipefail

    export IBIS_TEST_DATA_DIRECTORY
    IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    mkdir -p "$IBIS_TEST_DATA_DIRECTORY"

    # copy the test data to a directory
    rsync --chmod=Du+rwx,Fu+rw --archive "${ibisTestingData}/" "$IBIS_TEST_DATA_DIRECTORY"
  '';

  postCheck = ''
    rm -r "$IBIS_TEST_DATA_DIRECTORY"
  '';

  pythonImportsCheck = [
    "ibis"
  ] ++ map (backend: "ibis.backends.${backend}") testBackends;

  passthru = {
    optional-dependencies = {
      clickhouse = [ clickhouse-cityhash clickhouse-driver lz4 sqlglot ];
      dask = [ dask pyarrow ];
      datafusion = [ datafusion ];
      duckdb = [ duckdb duckdb-engine pyarrow sqlalchemy sqlglot ];
      geospatial = [ geoalchemy2 geopandas shapely ];
      mysql = [ sqlalchemy pymysql sqlglot ];
      pandas = [ ];
      postgres = [ psycopg2 sqlalchemy sqlglot ];
      pyspark = [ pyarrow pyspark ];
      sqlite = [ sqlalchemy sqlite sqlglot ];
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
