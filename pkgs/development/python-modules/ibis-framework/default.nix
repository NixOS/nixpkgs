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
    # https://github.com/ibis-project/ibis/blob/9.1.0/nix/overlay.nix#L20-L26
    rev = "6737d1cb5951cabaccd095a3ae62a93dbd11ecb9";
    hash = "sha256-MoVTZPWh4KVlrICYACrgfeLdl/fqoa1iweNg3zUtdrs=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "9.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
    hash = "sha256-GmzmXzYMs7K7B//is3ZoD4muPAkb0tM56zFBbsA+NEo=";
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
    # tries to download duckdb extensions
    "test_attach_sqlite"
    "test_connect_extensions"
    "test_load_extension"
    "test_read_sqlite"
    "test_register_sqlite"
    # requires network connection
    "test_s3_403_fallback"
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

  passthru = {
    optional-dependencies = {
      bigquery = [
        db-dtypes
        google-cloud-bigquery
        google-cloud-bigquery-storage
        pydata-google-auth
      ];
      clickhouse = [ clickhouse-connect ];
      dask = [
        dask
        regex
        packaging
      ];
      datafusion = [ datafusion ];
      druid = [ pydruid ];
      duckdb = [ duckdb ];
      flink = [ ];
      geospatial = [
        geopandas
        shapely
      ];
      mssql = [ pyodbc ];
      mysql = [ pymysql ];
      oracle = [
        oracledb
        packaging
      ];
      pandas = [
        regex
        packaging
      ];
      polars = [
        polars
        packaging
      ];
      postgres = [ psycopg2 ];
      pyspark = [
        pyspark
        packaging
      ];
      snowflake = [ snowflake-connector-python ];
      sqlite = [ regex ];
      trino = [ trino-python-client ];
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
