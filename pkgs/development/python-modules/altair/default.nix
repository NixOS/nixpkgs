{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  anywidget,
  ipython,
  ipywidgets,
  jinja2,
  jsonschema,
  mistune,
  narwhals,
  numpy,
  packaging,
  pandas,
  polars,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  toolz,
  typing-extensions,
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
  ++ lib.optional (pythonOlder "3.14") typing-extensions;

  nativeCheckInputs = [
    anywidget
    ipython
    ipywidgets
    mistune
    polars
    pytest-xdist
    pytestCheckHook
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
    "test_theme_remote_lambda"
    "test_chart_validation_errors"
    "test_multiple_field_strings_in_condition"
  ];

  disabledTestPaths = [
    # Disabled because it requires internet connectivity
    "tests/test_examples.py"
    "tests/test_datasets.py"
    "altair/datasets/_data.py"
    # TODO: Disabled because of missing altair_viewer package
    "tests/vegalite/v6/test_api.py"
    # avoid updating files and dependency on black
    "tests/test_toplevel.py"
    # require vl-convert package
    "tests/utils/test_compiler.py"
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
