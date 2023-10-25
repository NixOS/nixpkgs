{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# Runtime dependencies
, hatchling
, toolz
, numpy
, jsonschema
, typing-extensions
, pandas
, jinja2
, packaging

# Build, dev and test dependencies
, anywidget
, ipython
, pytestCheckHook
, vega_datasets
, sphinx
}:

buildPythonPackage rec {
  pname = "altair";
  version = "5.1.2";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "altair-viz";
    repo = "altair";
    rev = "refs/tags/v${version}";
    hash = "sha256-30M+rt5IfD4hvK5CwaW8HfQacDBPjowff/f9o7iido0=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    jinja2
    jsonschema
    numpy
    packaging
    pandas
    toolz
  ] ++ lib.optional (pythonOlder "3.11") typing-extensions;

  nativeCheckInputs = [
    anywidget
    ipython
    sphinx
    vega_datasets
    pytestCheckHook
  ];

  pythonImportsCheck = [ "altair" ];

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
    description = "A declarative statistical visualization library for Python.";
    homepage = "https://altair-viz.github.io";
    downloadPage = "https://github.com/altair-viz/altair";
    changelog = "https://altair-viz.github.io/releases/changes.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh vinetos ];
  };
}
