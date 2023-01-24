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
, hypothesis
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
, pytest-mock
, pytest-randomly
, pytest-snapshot
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
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "ibis";
    owner = "ibis-project";
    rev = version;
    hash = "sha256-G3kMd6Jyib7ZXHFP6t2CEPlDD5n5zHE2jq/0he3U4Nk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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
    hypothesis
    pytest-benchmark
    pytest-mock
    pytest-randomly
    pytest-snapshot
    pytest-xdist
    rsync
  ] ++ lib.concatMap (name: passthru.optional-dependencies.${name}) testBackends;

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
  ];

  # remove when sqlalchemy backend no longer uses deprecated methods
  SQLALCHEMY_SILENCE_UBER_WARNING = 1;

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
  '';

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
