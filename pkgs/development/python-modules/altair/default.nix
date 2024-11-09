{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  ipython,
  ipywidgets,
  jinja2,
  jsonschema,
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
  vega-datasets,
}:

buildPythonPackage rec {
  pname = "altair";
  version = "5.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "altair-viz";
    repo = "altair";
    rev = "refs/tags/v${version}";
    hash = "sha256-7C51ACaBuNtOSXqLpuCI5bnLyE9U64vNXlD4/msPq2k=";
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
  ] ++ lib.optional (pythonOlder "3.14") typing-extensions;

  nativeCheckInputs = [
    ipython
    ipywidgets
    polars
    pytest-xdist
    pytestCheckHook
    vega-datasets
  ];

  pythonImportsCheck = [ "altair" ];

  disabledTests = [
    # ValueError: Saving charts in 'svg' format requires the vl-convert-python or altair_saver package: see http://github.com/altair-viz/altair_saver/
    "test_renderer_with_none_embed_options"
  ];

  disabledTestPaths = [
    # Disabled because it requires internet connectivity
    "tests/test_examples.py"
    # TODO: Disabled because of missing altair_viewer package
    "tests/vegalite/v5/test_api.py"
    # avoid updating files and dependency on black
    "tests/test_toplevel.py"
    # require vl-convert package
    "tests/utils/test_compiler.py"
  ];

  meta = with lib; {
    description = "Declarative statistical visualization library for Python";
    homepage = "https://altair-viz.github.io";
    downloadPage = "https://github.com/altair-viz/altair";
    changelog = "https://altair-viz.github.io/releases/changes.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      teh
      vinetos
    ];
  };
}
