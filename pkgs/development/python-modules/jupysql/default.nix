{
  lib,
  stdenv,
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
  matplotlib,
  numpy,
  pandas,
  polars,
  pyarrow,
  pyspark,

  # tests
  pytestCheckHook,
  psutil,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "jupysql";
  version = "0.11.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ploomber";
    repo = "jupysql";
    tag = version;
    hash = "sha256-7wfKvKqDf8LlUiLoevNRxmq8x5wLheOgIeWz72oFcuw=";
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
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.dev;

  disabledTests = [
    # AttributeError: 'DataFrame' object has no attribute 'frame_equal'
    "test_resultset_polars_dataframe"

    # all of these are broken with later versions of duckdb; see
    # https://github.com/ploomber/jupysql/issues/1030
    "test_resultset_getitem"
    "test_resultset_dict"
    "test_resultset_len"
    "test_resultset_dicts"
    "test_resultset_dataframe"
    "test_resultset_csv"
    "test_resultset_str"
    "test_resultset_repr_html_when_feedback_is_2"
    "test_resultset_repr_html_with_reduced_feedback"
    "test_invalid_operation_error"
    "test_resultset_config_autolimit_dict"

    # fails due to strict warnings
    "test_calling_legacy_plotting_functions_displays_warning"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    "test_no_errors_with_stored_query"
  ];

  disabledTestPaths = [
    # require docker
    "src/tests/integration"

    # want to download test data from the network
    "src/tests/test_parse.py"
    "src/tests/test_ggplot.py"
    "src/tests/test_plot.py"
    "src/tests/test_magic.py"
    "src/tests/test_magic_plot.py"

    # require js2py (which is unmaintained and insecure)
    "src/tests/test_widget.py"
  ];

  pythonImportsCheck = [ "sql" ];

  meta = {
    description = "Better SQL in Jupyter";
    homepage = "https://github.com/ploomber/jupysql";
    changelog = "https://github.com/ploomber/jupysql/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ euxane ];
  };
}
