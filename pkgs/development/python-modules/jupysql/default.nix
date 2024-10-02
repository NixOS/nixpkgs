{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  ipython-genutils,
  jinja2,
  jupysql-plugin,
  ploomber-core,
  prettytable,
  sqlalchemy,
  sqlglot,
  sqlparse,

  # optional-dependencies
  duckdb,
  duckdb-engine,
  grpcio,
  ipython,
  ipywidgets,
  js2py,
  matplotlib,
  numpy,
  pandas,
  polars,
  pyarrow,
  pyspark,

  # tests
  pytestCheckHook,
  psutil,
}:

buildPythonPackage rec {
  pname = "jupysql";
  version = "0.10.13";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "jupysql";
    rev = "refs/tags/${version}";
    hash = "sha256-vNuMGHFkatJS5KjxaOBwZ7JolIDAdYqGq3JNKSV2fKE=";
  };

  pythonRelaxDeps = [ "sqlalchemy" ];

  build-system = [ setuptools ];

  dependencies = [
    ipython-genutils
    jinja2
    jupysql-plugin
    ploomber-core
    prettytable
    sqlalchemy
    sqlglot
    sqlparse
  ];

  optional-dependencies.dev = [
    duckdb
    duckdb-engine
    grpcio
    ipython
    ipywidgets
    js2py
    matplotlib
    numpy
    pandas
    polars
    pyarrow
    pyspark
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil
  ] ++ optional-dependencies.dev;

  disabledTests = [
    # AttributeError: 'DataFrame' object has no attribute 'frame_equal'
    "test_resultset_polars_dataframe"
  ];

  disabledTestPaths = [
    # require docker
    "src/tests/integration"

    # require network access
    "src/tests/test_telemetry.py"

    # want to download test data from the network
    "src/tests/test_parse.py"
    "src/tests/test_ggplot.py"
    "src/tests/test_plot.py"
    "src/tests/test_magic.py"
    "src/tests/test_magic_plot.py"
  ];

  preCheck = ''
    # tests need to write temp data
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "sql" ];

  meta = {
    description = "Better SQL in Jupyter";
    homepage = "https://github.com/ploomber/jupysql";
    changelog = "https://github.com/ploomber/jupysql/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pacien ];
  };
}
