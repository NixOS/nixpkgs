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
, importlib-metadata

# Build, dev and test dependencies
, ipython
, pytestCheckHook
, vega_datasets
, sphinx
}:

buildPythonPackage rec {
  pname = "altair";
  version = "5.0.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "altair-viz";
    repo = "altair";
    rev = "refs/tags/v${version}";
    hash = "sha256-7bTrfryu4oaodVGNFNlVk9vXmDA5/9ahvCmvUGzZ5OQ=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    jinja2
    jsonschema
    numpy
    pandas
    toolz
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata
    ++ lib.optional (pythonOlder "3.11") typing-extensions;

  nativeCheckInputs = [
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
  ];

  meta = with lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = "https://altair-viz.github.io";
    downloadPage = "https://github.com/altair-viz/altair";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh vinetos ];
  };
}
