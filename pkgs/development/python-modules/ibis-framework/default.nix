{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  atpublic,
  bidict,
  black,
  clickhouse-connect,
  dask,
  datafusion,
  db-dtypes,
  duckdb,
  duckdb-engine,
  filelock,
  geoalchemy2,
  geopandas,
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
  graphviz,
  hypothesis,
  multipledispatch,
  numpy,
  oracledb,
  packaging,
  pandas,
  parsy,
  pins,
  poetry-core,
  poetry-dynamic-versioning,
  polars,
  psycopg2,
  pyarrow,
  pyarrow-hotfix,
  pydata-google-auth,
  pydruid,
  pymysql,
  pyodbc,
  pyspark,
  pytest-benchmark,
  pytest-httpserver,
  pytest-mock,
  pytest-randomly,
  pytest-snapshot,
  pytest-timeout,
  pytest-xdist,
  python-dateutil,
  pytz,
  regex,
  rich,
  shapely,
  snowflake-connector-python,
  snowflake-sqlalchemy,
  sqlalchemy,
  sqlalchemy-views,
  sqlglot,
  sqlite,
  toolz,
  trino-python-client,
  typing-extensions,
}:
let
  testBackends = [
    "datafusion"
    "duckdb"
    "pandas"
    "sqlite"
  ];

  ibisTestingData = fetchFromGitHub {
    name = "ibis-testing-data";
    owner = "ibis-project";
    repo = "testing-data";
    # https://github.com/ibis-project/ibis/blob/9.0.0/nix/overlay.nix#L20-L26
    rev = "1922bd4617546b877e66e78bb2b87abeb510cf8e";
    hash = "sha256-l5d7r/6Voy6N2pXq3IivLX3N0tNfKKwsbZXRexzc8Z8=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "9.0.0-unstable-2024-06-03";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "395c8b539bcd541d36892d95f413dcc3f93ca0bc";
    hash = "sha256-PPjp8HOwM4IaBz7TBGDgkVytHmX9fKO+ZBR33BoB55s=";
  };

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dontBypassPoetryDynamicVersioning = true;
  env.POETRY_DYNAMIC_VERSIONING_BYPASS = lib.head (lib.strings.splitString "-" version);

  propagatedBuildInputs = [
    atpublic
    bidict
    multipledispatch
    numpy
    pandas
    parsy
    pyarrow
    pyarrow-hotfix
    python-dateutil
    pytz
    rich
    sqlglot
    toolz
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    black
    filelock
    hypothesis
    pytest-benchmark
    pytest-httpserver
    pytest-mock
    pytest-randomly
    pytest-snapshot
    pytest-timeout
    pytest-xdist
  ] ++ lib.concatMap (name: passthru.optional-dependencies.${name}) testBackends;

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
  ];

  disabledTests = [
    # breakage from sqlalchemy2 truediv changes
    "test_tpc_h17"
    # tries to download duckdb extensions
    "test_attach_sqlite"
    "test_connect_extensions"
    "test_load_extension"
    "test_read_sqlite"
    "test_register_sqlite"
    # duckdb does not respect sample_size=2 (reads 3 lines of csv).
    "test_csv_reregister_schema"
    # duckdb fails with:
    # "This function can not be called with an active transaction!, commit or abort the existing one first"
    "test_vectorized_udf"
    "test_s3_403_fallback"
    "test_map_merge_udf"
    "test_udf"
    "test_map_udf"
    # DataFusion error
    "datafusion"
    # pluggy.PluggyTeardownRaisedWarning
    "test_repr_png_is_not_none_in_not_interactive"
    "test_interval_arithmetic"
  ];

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
  '';

  preCheck = ''
    HOME="$TMPDIR"
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    # copy the test data to a directory
    ln -s "${ibisTestingData}" "$IBIS_TEST_DATA_DIRECTORY"
  '';

  postCheck = ''
    rm -r "$IBIS_TEST_DATA_DIRECTORY"
  '';

  pythonImportsCheck = [ "ibis" ] ++ map (backend: "ibis.backends.${backend}") testBackends;

  passthru = {
    optional-dependencies = {
      bigquery = [
        db-dtypes
        google-cloud-bigquery
        google-cloud-bigquery-storage
        pydata-google-auth
      ];
      clickhouse = [
        clickhouse-connect
        sqlalchemy
      ];
      dask = [
        dask
        regex
      ];
      datafusion = [ datafusion ];
      druid = [
        pydruid
        sqlalchemy
      ];
      duckdb = [
        duckdb
        duckdb-engine
        sqlalchemy
        sqlalchemy-views
      ];
      flink = [ ];
      geospatial = [
        geoalchemy2
        geopandas
        shapely
      ];
      mssql = [
        sqlalchemy
        pyodbc
        sqlalchemy-views
      ];
      mysql = [
        sqlalchemy
        pymysql
        sqlalchemy-views
      ];
      oracle = [
        sqlalchemy
        oracledb
        packaging
        sqlalchemy-views
      ];
      pandas = [ regex ];
      polars = [
        polars
        packaging
      ];
      postgres = [
        psycopg2
        sqlalchemy
        sqlalchemy-views
      ];
      pyspark = [
        pyspark
        sqlalchemy
        packaging
      ];
      snowflake = [
        snowflake-connector-python
        snowflake-sqlalchemy
        sqlalchemy-views
        packaging
      ];
      sqlite = [
        regex
        sqlalchemy
        sqlalchemy-views
      ];
      trino = [
        trino-python-client
        sqlalchemy
        sqlalchemy-views
      ];
      visualization = [ graphviz ];
      decompiler = [ black ];
      examples = [ pins ] ++ pins.optional-dependencies.gcs;
    };
  };

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    changelog = "https://github.com/ibis-project/ibis/blob/${version}/docs/release_notes.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
