{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  prettytable,
  sqlalchemy,
  sqlparse,
  ipython-genutils,
  jinja2,
  sqlglot,
  jupysql-plugin,
  ploomber-core,
  ploomber-extension,
  ipython,
  duckdb,
  duckdb-engine,
  matplotlib,
  polars,
  ipywidgets,
  numpy,
  pandas,
  js2py,
  pyspark,
  pyarrow,
  grpcio,
  pytestCheckHook,
  psutil,
}:

buildPythonPackage rec {
  pname = "jupysql";
  version = "0.10.11";

  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "jupysql";
    rev = "refs/tags/${version}";
    hash = "sha256-A9zTjH+9RYKcgy4mI6uOMHOc46om06y1zK3IbxeVcWE=";
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
    ploomber-extension
  ];

  optional-dependencies.dev = [
    ipython
    duckdb
    duckdb-engine
    matplotlib
    polars
    ipywidgets
    numpy
    pandas
    js2py
    pyspark
    pyarrow
    grpcio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    psutil
  ] ++ optional-dependencies.dev;

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

  meta = with lib; {
    description = "Better SQL in Jupyter";
    homepage = "https://github.com/ploomber/jupysql";
    changelog = "https://github.com/ploomber/jupysql/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ pacien ];
  };
}
