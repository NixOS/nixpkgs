{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
, atpublic
, bidict
, black
, clickhouse-cityhash
, clickhouse-driver
, dask
, datafusion
, db-dtypes
, duckdb
, duckdb-engine
, filelock
, geoalchemy2
, geopandas
, google-cloud-bigquery
, google-cloud-bigquery-storage
, graphviz-nox
, hypothesis
, importlib-resources
, lz4
, multipledispatch
, numpy
, packaging
, pandas
, parsy
, poetry-core
, polars
, pooch
, psycopg2
, pyarrow
, pydata-google-auth
, pydruid
, pymysql
, pyspark
, pytest-benchmark
, pytest-httpserver
, pytest-mock
, pytest-randomly
, pytest-snapshot
, pytest-xdist
, python-dateutil
, pytz
, regex
, rich
, rsync
, shapely
, snowflake-connector-python
, snowflake-sqlalchemy
, sqlalchemy
, sqlalchemy-views
, sqlglot
, sqlite
, toolz
, trino-python-client
, typing-extensions
}:
let
  testBackends = [ "datafusion" "duckdb" "pandas" "sqlite" ];

  ibisTestingData = fetchFromGitHub {
    name = "ibis-testing-data";
    owner = "ibis-project";
    repo = "testing-data";
    rev = "8a59df99c01fa217259554929543e71c3bbb1761";
    hash = "sha256-NbgEe0w/qf9hCr9rRfIpyaH9pv25I8x0ykY7EJxDOuk=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
    hash = "sha256-u3BBGdhWajZ5WtoBvNxmx76+orfHY6LX3IWAq/x2/9A=";
  };

  patches = [
    # fixes a small bug in the datafusion backend to reorder predicates
    (fetchpatch {
      name = "fix-datafusion-compilation.patch";
      url = "https://github.com/ibis-project/ibis/commit/009230421b2bc1f86591e8b850d37a489e8e4f06.patch";
      hash = "sha256-5NHkgc8d2bkOMpbY1vme1XgNfyHSr0f7BrR3JTTjjPI=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    atpublic
    bidict
    multipledispatch
    numpy
    pandas
    parsy
    pooch
    python-dateutil
    pytz
    rich
    sqlglot
    toolz
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ]
  ++ pooch.optional-dependencies.progress
  ++ pooch.optional-dependencies.xxhash;

  nativeCheckInputs = [
    pytestCheckHook
    filelock
    hypothesis
    pytest-benchmark
    pytest-httpserver
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
    # sqlalchemy2 breakage
    "--deselect=ibis/tests/sql/test_sqlalchemy.py::test_tpc_h17"
    # tries to download duckdb extensions
    "--deselect=ibis/backends/duckdb/tests/test_register.py::test_register_sqlite"
    "--deselect=ibis/backends/duckdb/tests/test_register.py::test_read_sqlite"
  ];

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
  '';

  preCheck = ''
    set -eo pipefail

    HOME="$TMPDIR"
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

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
      bigquery = [ db-dtypes google-cloud-bigquery google-cloud-bigquery-storage pydata-google-auth ];
      clickhouse = [ clickhouse-cityhash clickhouse-driver lz4 sqlalchemy ];
      dask = [ dask pyarrow regex ];
      datafusion = [ datafusion ];
      druid = [ pydruid sqlalchemy ];
      duckdb = [ duckdb duckdb-engine packaging pyarrow sqlalchemy sqlalchemy-views ];
      geospatial = [ geoalchemy2 geopandas shapely ];
      mysql = [ sqlalchemy pymysql sqlalchemy-views ];
      pandas = [ regex ];
      polars = [ polars pyarrow ];
      postgres = [ psycopg2 sqlalchemy sqlalchemy-views ];
      pyspark = [ pyarrow pyspark sqlalchemy ];
      snowflake = [ snowflake-connector-python snowflake-sqlalchemy sqlalchemy-views ];
      sqlite = [ regex sqlalchemy sqlite sqlalchemy-views ];
      trino = [ trino-python-client sqlalchemy sqlalchemy-views ];
      visualization = [ graphviz-nox ];
      decompiler = [ black ];
    };
  };

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    changelog = "https://github.com/ibis-project/ibis/blob/${version}/docs/release_notes.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc cpcloud ];
  };
}
