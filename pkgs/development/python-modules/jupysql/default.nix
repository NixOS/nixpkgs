{
  lib,
  buildPythonPackage,
  duckdb-engine,
  duckdb,
  fetchFromGitHub,
  grpcio,
  ipython-genutils,
  ipython,
  ipywidgets,
  jinja2,
  js2py,
  jupysql-plugin,
  matplotlib,
  numpy,
  pandas,
  ploomber-core,
  polars,
  prettytable,
  psutil,
  pyarrow,
  pyspark,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sqlalchemy,
  sqlglot,
  sqlparse,
}:

buildPythonPackage rec {
  pname = "jupysql";
  version = "0.10.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "jupysql";
    rev = "refs/tags/${version}";
    hash = "sha256-vNuMGHFkatJS5KjxaOBwZ7JolIDAdYqGq3JNKSV2fKE=";
  };

  pythonRelaxDeps = [ "sqlalchemy" ];

  build-system = [ setuptools ];

  dependencies = [
    prettytable
    sqlalchemy
    sqlparse
    ipython-genutils
    jinja2
    sqlglot
    jupysql-plugin
    ploomber-core
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
    # AttributeError
    "test_resultset_polars_dataframe"
  ];

  disabledTestPaths = [
    # Tests require docker
    "src/tests/integration"
    # Tests require network access
    "src/tests/test_telemetry.py"
    # Tests want to download test data from the network
    "src/tests/test_parse.py"
    "src/tests/test_ggplot.py"
    "src/tests/test_plot.py"
    "src/tests/test_magic.py"
    "src/tests/test_magic_plot.py"
  ];

  preCheck = ''
    # Tests need to write temp data
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "sql" ];

  meta = with lib; {
    description = "Better SQL in Jupyter";
    homepage = "https://github.com/ploomber/jupysql";
    changelog = "https://github.com/ploomber/jupysql/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ pacien ];
  };
}
