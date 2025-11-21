{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  atpublic,
  parsy,
  python-dateutil,
  sqlglot,
  toolz,
  typing-extensions,
  tzdata,

  # tests
  pytestCheckHook,
  black,
  filelock,
  hypothesis,
  pytest-benchmark,
  pytest-httpserver,
  pytest-mock,
  pytest-randomly,
  pytest-snapshot,
  pytest-timeout,
  pytest-xdist,
  writableTmpDirAsHomeHook,

  # optional-dependencies
  # - athena
  pyathena,
  fsspec,
  # - bigquery
  db-dtypes,
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
  pyarrow,
  pyarrow-hotfix,
  pydata-google-auth,
  numpy,
  pandas,
  rich,
  # - clickhouse
  clickhouse-connect,
  # - databricks
  # databricks-sql-connector-core, (unpackaged)
  # - datafusion
  datafusion,
  # - druid
  pydruid,
  # - duckdb
  duckdb,
  packaging,
  # - flink
  # - geospatial
  geopandas,
  shapely,
  # - mssql
  pyodbc,
  # - mysql
  pymysql,
  # - oracle
  oracledb,
  # - polars
  polars,
  # - postgres
  psycopg2,
  # - pyspark
  pyspark,
  # - snowflake
  snowflake-connector-python,
  # sqlite
  regex,
  # - trino
  trino-python-client,
  # - visualization
  graphviz,
  # examples
  pins,
}:
let
  testBackends = [
    "duckdb"
    "sqlite"
  ];

  ibisTestingData = fetchFromGitHub {
    owner = "ibis-project";
    repo = "testing-data";
    # https://github.com/ibis-project/ibis/blob/10.5.0/nix/overlay.nix#L94-L100
    rev = "b26bd40cf29004372319df620c4bbe41420bb6f8";
    hash = "sha256-1fenQNQB+Q0pbb0cbK2S/UIwZDE4PXXG15MH3aVbyLU=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "11.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ibis-project";
    repo = "ibis";
    tag = version;
    hash = "sha256-hf5guWeX9WQbKaNrs7ALwwDxV1Rgeb5Z0PedTQ4P7S0=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    atpublic
    parsy
    python-dateutil
    sqlglot
    toolz
    typing-extensions
    tzdata
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
    # this dependency is still needed due to use of strict markers and
    # `pytest.mark.xdist_group` in the ibis codebase
    pytest-xdist
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatMap (name: optional-dependencies.${name}) testBackends;

  pytestFlags = [
    "--benchmark-disable"
    "-Wignore::FutureWarning"
  ];

  enabledTestMarks = testBackends ++ [ "core" ];

  disabledTests = [
    # tries to download duckdb extensions
    "test_attach_sqlite"
    "test_connect_extensions"
    "test_load_extension"
    "test_read_csv_with_types"
    "test_read_sqlite"
    "test_register_sqlite"
    "test_roundtrip_xlsx"

    # AssertionError: value does not match the expected value in snapshot
    "test_union_aliasing"

    # requires network connection
    "test_s3_403_fallback"
    "test_hugging_face"

    # requires pytest 8.2+
    "test_roundtrip_delta"

    # AssertionError: value does not match the expected value in snapshot ibis/backends/tests/snapshots/test_sql/test_rewrite_context/sqlite/out.sql
    "test_rewrite_context"

    # Assertion error comparing a calculated version string with the actual (during nixpkgs-review)
    "test_builtin_scalar_noargs"

    # duckdb ParserError: syntax error at or near "AT"
    "test_90"

    # assert 0 == 3 (tests edge case behavior of databases)
    "test_self_join_with_generated_keys"
  ];

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
  '';

  preCheck = ''
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    # copy the test data to a directory
    ln -s "${ibisTestingData}" "$IBIS_TEST_DATA_DIRECTORY"
  '';

  postCheck = ''
    rm -r "$IBIS_TEST_DATA_DIRECTORY"
  '';

  pythonImportsCheck = [ "ibis" ] ++ map (backend: "ibis.backends.${backend}") testBackends;

  optional-dependencies = {
    athena = [
      pyathena
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
      packaging
      fsspec
    ];
    bigquery = [
      db-dtypes
      google-cloud-bigquery
      google-cloud-bigquery-storage
      pyarrow
      pyarrow-hotfix
      pydata-google-auth
      numpy
      pandas
      rich
    ];
    clickhouse = [
      clickhouse-connect
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    databricks = [
      # databricks-sql-connector-core (unpackaged)
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    datafusion = [
      datafusion
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    druid = [
      pydruid
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    duckdb = [
      duckdb
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
      packaging
    ];
    flink = [
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    geospatial = [
      geopandas
      shapely
    ];
    mssql = [
      pyodbc
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    mysql = [
      pymysql
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    oracle = [
      oracledb
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    polars = [
      polars
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    postgres = [
      psycopg2
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    pyspark = [
      pyspark
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    snowflake = [
      snowflake-connector-python
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    sqlite = [
      regex
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    trino = [
      trino-python-client
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    visualization = [ graphviz ];
    decompiler = [ black ];
    examples = [ pins ] ++ pins.optional-dependencies.gcs;
  };

  meta = {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    changelog = "https://github.com/ibis-project/ibis/blob/${src.tag}/docs/release_notes.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cpcloud
      sarahec
    ];
  };
}
