{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, atpublic
, bidict
, black
, clickhouse-connect
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
, multipledispatch
, numpy
, oracledb
, packaging
, pandas
, parsy
, poetry-core
, poetry-dynamic-versioning
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
    rev = "2b3968deaa1a28791b2901dbbcc9bfd3d2f23e9b";
    hash = "sha256-q1b5IcOl5oIFXP7/P5RufncjHEVrWp4NjoU2uo/BE9U=";
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
  version = "6.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
    hash = "sha256-+AtXgRNxPryP/fd/GQlLNxWbP6ozikqG2yBCp3dE0tY=";
  };

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
    # breakage from sqlalchemy2 truediv changes
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
    substituteInPlace pyproject.toml --replace 'sqlglot = ">=10.4.3,<12"' 'sqlglot = "*"'
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
