{ lib
, atpublic
, bidict
, black
, buildPythonPackage
, clickhouse-connect
, dask
, datafusion
, db-dtypes
, duckdb
, duckdb-engine
, fetchFromGitHub
, filelock
, geoalchemy2
, geopandas
, google-cloud-bigquery
, google-cloud-bigquery-storage
, graphviz-nox
, hypothesis
, multipledispatch
, numpy
, oracledb
, packaging
, pandas
, parsy
, pins
, poetry-core
, poetry-dynamic-versioning
, polars
, pooch
, psycopg2
, pyarrow
, pyarrow-hotfix
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
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, regex
, rich
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
    # https://github.com/ibis-project/ibis/blob/7.1.0/nix/overlay.nix#L20-L26
    rev = "2c6a4bb5d5d525058d8d5b2312a9fee5dafc5476";
    hash = "sha256-Lq503bqh9ESZJSk6yVq/uZwkAubzmSmoTBZSsqMm0DY=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "8.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
    hash = "sha256-KcNZslqmSbu8uPYKpkyvd7d8Fsf0nQt80y0auXsI8fs=";
  };

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
  ];

  POETRY_DYNAMIC_VERSIONING_BYPASS = version;

  propagatedBuildInputs = [
    atpublic
    bidict
    filelock
    multipledispatch
    numpy
    pandas
    parsy
    pooch
    pyarrow
    pyarrow-hotfix
    python-dateutil
    pytz
    rich
    sqlglot
    toolz
    typing-extensions
  ]
  ++ pooch.optional-dependencies.progress
  ++ pooch.optional-dependencies.xxhash;

  nativeCheckInputs = [
    black
    pytestCheckHook
    hypothesis
    pytest-benchmark
    pytest-httpserver
    pytest-mock
    pytest-randomly
    pytest-snapshot
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
    "test_register_sqlite"
    "test_read_sqlite"
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

  preCheck = ''
    HOME="$TMPDIR"
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    # copy the test data to a directory
    ln -s "${ibisTestingData}" "$IBIS_TEST_DATA_DIRECTORY"
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
      clickhouse = [ clickhouse-connect sqlalchemy ];
      dask = [ dask regex ];
      datafusion = [ datafusion ];
      druid = [ pydruid sqlalchemy ];
      duckdb = [ duckdb duckdb-engine packaging sqlalchemy sqlalchemy-views ];
      flink = [ ];
      geospatial = [ geoalchemy2 geopandas shapely ];
      mysql = [ sqlalchemy pymysql sqlalchemy-views ];
      oracle = [ sqlalchemy oracledb packaging sqlalchemy-views ];
      pandas = [ regex ];
      polars = [ polars ];
      postgres = [ psycopg2 sqlalchemy sqlalchemy-views ];
      pyspark = [ pyspark sqlalchemy ];
      snowflake = [ snowflake-connector-python snowflake-sqlalchemy sqlalchemy-views ];
      sqlite = [ regex sqlalchemy sqlite sqlalchemy-views ];
      trino = [ trino-python-client sqlalchemy sqlalchemy-views ];
      visualization = [ graphviz-nox ];
      decompiler = [ black ];
      # deltalake = [ deltalake ];  # Dependency missing in Nixpkgs
      examples = [ pins ];
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
