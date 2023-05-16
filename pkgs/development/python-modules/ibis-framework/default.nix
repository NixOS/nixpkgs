{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pythonOlder
, pytestCheckHook
, atpublic
, bidict
, black
<<<<<<< HEAD
, clickhouse-connect
=======
, clickhouse-cityhash
, clickhouse-driver
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, multipledispatch
, numpy
, oracledb
=======
, importlib-resources
, lz4
, multipledispatch
, numpy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, packaging
, pandas
, parsy
, poetry-core
<<<<<<< HEAD
, poetry-dynamic-versioning
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
, rsync
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    rev = "2b3968deaa1a28791b2901dbbcc9bfd3d2f23e9b";
    hash = "sha256-q1b5IcOl5oIFXP7/P5RufncjHEVrWp4NjoU2uo/BE9U=";
=======
    rev = "8a59df99c01fa217259554929543e71c3bbb1761";
    hash = "sha256-NbgEe0w/qf9hCr9rRfIpyaH9pv25I8x0ykY7EJxDOuk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in

buildPythonPackage rec {
  pname = "ibis-framework";
<<<<<<< HEAD
  version = "6.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";
=======
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    name = "ibis-source";
    repo = "ibis";
    owner = "ibis-project";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    multipledispatch
    numpy
    pandas
    parsy
    pooch
<<<<<<< HEAD
    pyarrow
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    python-dateutil
    pytz
    rich
    sqlglot
    toolz
    typing-extensions
<<<<<<< HEAD
  ]
=======
  ] ++ lib.optionals (pythonOlder "3.9") [ importlib-resources ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ++ pooch.optional-dependencies.progress
  ++ pooch.optional-dependencies.xxhash;

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
=======
    filelock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hypothesis
    pytest-benchmark
    pytest-httpserver
    pytest-mock
    pytest-randomly
    pytest-snapshot
    pytest-xdist
<<<<<<< HEAD
=======
    rsync
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.concatMap (name: passthru.optional-dependencies.${name}) testBackends;

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
<<<<<<< HEAD
    # breakage from sqlalchemy2 truediv changes
=======
    # sqlalchemy2 breakage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--deselect=ibis/tests/sql/test_sqlalchemy.py::test_tpc_h17"
    # tries to download duckdb extensions
    "--deselect=ibis/backends/duckdb/tests/test_register.py::test_register_sqlite"
    "--deselect=ibis/backends/duckdb/tests/test_register.py::test_read_sqlite"
<<<<<<< HEAD
    # pyarrow13 is not supported yet.
    "--deselect=ibis/backends/tests/test_temporal.py::test_date_truncate"
    "--deselect=ibis/backends/tests/test_temporal.py::test_integer_to_interval_timestamp"
    "--deselect=ibis/backends/tests/test_temporal.py::test_integer_to_interval_timestamp"
    "--deselect=ibis/backends/tests/test_temporal.py::test_interval_add_cast_column"
    "--deselect=ibis/backends/tests/test_temporal.py::test_integer_to_interval_timestamp"
    "--deselect=ibis/backends/tests/test_temporal.py::test_integer_to_interval_timestamp"
    "--deselect=ibis/backends/tests/test_temporal.py::test_integer_to_interval_timestamp"
    "--deselect=ibis/backends/tests/test_temporal.py::test_integer_to_interval_timestamp"
    "--deselect=ibis/backends/tests/test_timecontext.py::test_context_adjustment_filter_before_window"
    "--deselect=ibis/backends/tests/test_timecontext.py::test_context_adjustment_window_udf"
    "--deselect=ibis/backends/tests/test_timecontext.py::test_context_adjustment_window_udf"
    "--deselect=ibis/backends/tests/test_aggregation.py::test_aggregate_grouped"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # patch out tests that check formatting with black
  postPatch = ''
    find ibis/tests -type f -name '*.py' -exec sed -i \
      -e '/^ *assert_decompile_roundtrip/d' \
      -e 's/^\( *\)code = ibis.decompile(expr, format=True)/\1code = ibis.decompile(expr)/g' {} +
<<<<<<< HEAD
    substituteInPlace pyproject.toml --replace 'sqlglot = ">=10.4.3,<12"' 'sqlglot = "*"'
  '';

  preCheck = ''
    HOME="$TMPDIR"
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    # copy the test data to a directory
    ln -s "${ibisTestingData}" "$IBIS_TEST_DATA_DIRECTORY"
=======
  '';

  preCheck = ''
    set -eo pipefail

    HOME="$TMPDIR"
    export IBIS_TEST_DATA_DIRECTORY="ci/ibis-testing-data"

    mkdir -p "$IBIS_TEST_DATA_DIRECTORY"

    # copy the test data to a directory
    rsync --chmod=Du+rwx,Fu+rw --archive "${ibisTestingData}/" "$IBIS_TEST_DATA_DIRECTORY"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ cpcloud ];
=======
    maintainers = with maintainers; [ costrouc cpcloud ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
