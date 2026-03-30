{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  jinja2,
  jsonschema,
  narwhals,
  numpy,
  packaging,
  pandas,
  toolz,
  typing-extensions,

  # tests
  anywidget,
  ipython,
  ipywidgets,
  mistune,
  polars,
  pytest-xdist,
  pytestCheckHook,
  vega-datasets,
  vl-convert-python,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "altair";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altair-viz";
    repo = "altair";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Qc51L4tL1pRDpWwadxPpTE4tDH3FTO/wH67FtXMN7k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jinja2
    jsonschema
    narwhals
    numpy
    packaging
    pandas
    toolz
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    typing-extensions
  ];

  nativeCheckInputs = [
    anywidget
    ipython
    ipywidgets
    mistune
    polars
    pytest-xdist
    pytestCheckHook
    vega-datasets
    vl-convert-python
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "altair" ];

  enabledTestPaths = [
    "tests/"
  ];

  disabledTests = [
    # ValueError: Saving charts in 'svg' format requires the vl-convert-python or altair_saver package: see http://github.com/altair-viz/altair_saver/
    "test_renderer_with_none_embed_options"

    # Sometimes conflict due to parallelism
    "test_dataframe_to_csv[polars]"
    "test_dataframe_to_csv[pandas]"

    # Network access
    "test_chart_validation_errors"
    "test_data_consistency"
    "test_load_call"
    "test_loader_call"
    "test_multiple_field_strings_in_condition"
    "test_no_remote_connection"
    "test_pandas_date_parse"
    "test_pandas_date_parse"
    "test_polars_date_read_json_roundtrip"
    "test_polars_date_read_json_roundtrip"
    "test_polars_date_read_json_roundtrip"
    "test_polars_date_read_json_roundtrip"
    "test_reader_cache"
    "test_theme_remote_lambda"
    "test_tsv"
  ];

  disabledTestPaths = [
    # Network access
    "altair/datasets/_data.py"
    "tests/test_examples.py"

    # avoid updating files and dependency on black
    "tests/test_toplevel.py"
  ];

  meta = {
    description = "Declarative statistical visualization library for Python";
    homepage = "https://altair-viz.github.io";
    downloadPage = "https://github.com/altair-viz/altair";
    changelog = "https://altair-viz.github.io/releases/changes.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      teh
      vinetos
    ];
  };
})
