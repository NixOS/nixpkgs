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
  filelock,
  fsspec,
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
  pyproj,
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
  sqlglot,
  sqlite,
  toolz,
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
    # https://github.com/ibis-project/ibis/blob/9.3.0/nix/overlay.nix#L20-L26
    rev = "b26bd40cf29004372319df620c4bbe41420bb6f8";
    hash = "sha256-1fenQNQB+Q0pbb0cbK2S/UIwZDE4PXXG15MH3aVbyLU=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "9.3.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
    hash = "sha256-+7QuNo3axtBAIQPUa+1MeKfv0diB1mct5GdJmztsnvo=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dontBypassPoetryDynamicVersioning = true;
  env.POETRY_DYNAMIC_VERSIONING_BYPASS = lib.head (lib.strings.splitString "-" version);

  dependencies = [
    atpublic
    parsy
    python-dateutil
    pytz
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
  ] ++ lib.concatMap (name: optional-dependencies.${name}) testBackends;

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
  ];

  disabledTests = [
    # tries to download duckdb extensions
    "test_attach_sqlite"
    "test_connect_extensions"
    "test_load_extension"
    "test_read_sqlite"
    "test_register_sqlite"
    # requires network connection
    "test_s3_403_fallback"
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

  optional-dependencies = {
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
    clickhouse =
      [
        clickhouse-connect
        pyarrow
        pyarrow-hotfix
        numpy
        pandas
        rich
      ]
      ++ clickhouse-connect.optional-dependencies.arrow
      ++ clickhouse-connect.optional-dependencies.numpy
      ++ clickhouse-connect.optional-dependencies.pandas;
    dask = [
      dask
      regex
      packaging
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ] ++ dask.optional-dependencies.array ++ dask.optional-dependencies.dataframe;
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
    ];
    exasol = [
      # pyexasol[pandas]
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    flink = [
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
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
    pandas = [
      regex
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
      # trino
      pyarrow
      pyarrow-hotfix
      numpy
      pandas
      rich
    ];
    visualization = [ graphviz ];
    decompiler = [ black ];
    examples = [
      pins
      fsspec
    ] ++ pins.optional-dependencies.gcs;
    geospatial = [
      # geoarrow-types
      geopandas
      pyproj
      shapely
    ];
  };

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    changelog = "https://github.com/ibis-project/ibis/blob/${version}/docs/release_notes.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
