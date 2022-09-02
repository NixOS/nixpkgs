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
, pytest-randomly
, pytest-mock
, pytest-xdist
, python
, pytz
, regex
, rsync
, shapely
, sqlalchemy
, sqlite
, tabulate
, toolz
}:
let
  testBackends = [
    "dask"
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
  version = "3.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "ibis";
    owner = "ibis-project";
    rev = version;
    hash = "sha256-/mQWQLiJa1DRZiyiA6F0/lMyn3wSY1IUwJl2S0IFkvs=";
  };

  patches = [
    (fetchpatch {
      name = "xfail-datafusion-0.4.0";
      url = "https://github.com/ibis-project/ibis/compare/c162abba4df24e0d531bd2e6a3be3109c16b43b9...6219d6caee19b6fd3171983c49cd8d6872e3564b.patch";
      hash = "sha256-pCYPntj+TwzqCtYWRf6JF5/tJC4crSXHp0aepRocHck=";
      excludes = ["poetry.lock"];
    })
  ];

  nativeBuildInputs = [ poetry-core ];

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
    tabulate
    toolz
  ];

  checkInputs = [
    pytestCheckHook
    click
    filelock
    pytest-benchmark
    pytest-mock
    pytest-randomly
    pytest-xdist
    rsync
  ] ++ lib.concatMap (name: passthru.optional-dependencies.${name}) testBackends;

  preBuild = ''
    # setup.py exists only for developer convenience and is automatically generated
    # it gets in the way in nixpkgs so we remove it
    rm setup.py
  '';

  pytestFlagsArray = [
    "--dist=loadgroup"
    "-m"
    "'${lib.concatStringsSep " or " testBackends} or core'"
    # this test fails on nixpkgs datafusion version (0.4.0), but works on
    # datafusion 0.6.0
    "-k"
    "'not datafusion-no_op'"
  ];

  preCheck = ''
    set -eo pipefail

    export IBIS_TEST_DATA_DIRECTORY
    IBIS_TEST_DATA_DIRECTORY="$(mktemp -d)"

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
      clickhouse = [ clickhouse-cityhash clickhouse-driver lz4 ];
      dask = [ dask pyarrow ];
      datafusion = [ datafusion ];
      duckdb = [ duckdb duckdb-engine sqlalchemy ];
      geospatial = [ geoalchemy2 geopandas shapely ];
      mysql = [ pymysql sqlalchemy ];
      pandas = [ ];
      postgres = [ psycopg2 sqlalchemy ];
      pyspark = [ pyarrow pyspark ];
      sqlite = [ sqlalchemy sqlite ];
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
