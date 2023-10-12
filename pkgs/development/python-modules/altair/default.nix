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
  # current version, 5.0.1, is broken with jsonschema>=4.18
  # we use unstable version instead of patch due to many changes
  version = "unstable-2023-08-12";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "altair-viz";
    repo = "altair";
    rev = "56b3b66daae7160c8d82777d2646131afcc3dab4";
    hash = "sha256-uVE3Bth1D1mIhaULB4IxEtOzhQd51Pscqyfdys65F6A=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh vinetos ];
  };
}
