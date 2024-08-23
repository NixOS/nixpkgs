{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  atpublic,
  black,
  clickhouse-connect,
  dask,
  datafusion,
  db-dtypes,
  duckdb,
  fetchpatch,
  filelock,
  geopandas,
  google-cloud-bigquery,
  google-cloud-bigquery-storage,
  graphviz,
  hypothesis,
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
  sqlglot,
  sqlite,
  toolz,
  trino-python-client,
  typing-extensions,
}:
let
  testBackends = [
    "duckdb"
    "sqlite"
    "datafusion"
  ];

  ibisTestingData = fetchFromGitHub {
    name = "ibis-testing-data";
    owner = "ibis-project";
    repo = "testing-data";
    # https://github.com/ibis-project/ibis/blob/9.5.0/nix/overlay.nix#L20-L26
    rev = "b26bd40cf29004372319df620c4bbe41420bb6f8";
    sha256 = "sha256-1fenQNQB+Q0pbb0cbK2S/UIwZDE4PXXG15MH3aVbyLU=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "9.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
    hash = "sha256-6ebw/E3jZFMHKqC5ZY//2Ke0NrklyoGp5JGKBfDxy40=";
  };

  patches = [
    # remove after the 10.0 release
    (fetchpatch {
      name = "ibis-framework-duckdb-1.1.1.patch";
      url = "https://github.com/ibis-project/ibis/commit/a54eceabac1d6592e9f6ab0ca7749e37a748c2ad.patch";
      hash = "sha256-j5BPYVqnEF9GQV5N3/VhFUCdsEwAIOQC0KfZ5LNBSRg=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dontBypassPoetryDynamicVersioning = true;
  env.POETRY_DYNAMIC_VERSIONING_BYPASS = lib.head (lib.strings.splitString "-" version);

  propagatedBuildInputs = [
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
    # this dependency is still needed due to use of strict markers and
    # `pytest.mark.xdist_group` in the ibis codebase
    pytest-xdist
  ] ++ lib.concatMap (name: optional-dependencies.${name}) testBackends;

  dontUsePytestXdist = true;

  pytestFlagsArray = [
    "-m"
    # tpcds and tpch are slow, so disable them
    "'not tpcds and not tpch and (${lib.concatStringsSep " or " testBackends} or core)'"
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
    "test_hugging_face"
    # requires pytest 8.2+
    "test_roundtrip_delta"
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
    clickhouse = [
      clickhouse-connect
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

  meta = with lib; {
    description = "Productivity-centric Python Big Data Framework";
    homepage = "https://github.com/ibis-project/ibis";
    changelog = "https://github.com/ibis-project/ibis/blob/${version}/docs/release_notes.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
