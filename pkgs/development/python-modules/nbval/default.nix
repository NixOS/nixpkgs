{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  coverage,
  ipykernel,
  jupyter-client,
  nbformat,
  pytestCheckHook,
  pytest,
  glibcLocales,
  matplotlib,
  sympy,
}:

buildPythonPackage rec {
  pname = "nbval";
  version = "0.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d8lXl2B7CpaLq9JZfuNJQQLSXDrTdDXeu9rA5G43kJQ=";
  };

  buildInputs = [ glibcLocales ];

  build-system = [ setuptools ];

  dependencies = [
    coverage
    ipykernel
    jupyter-client
    nbformat
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    sympy
  ];

  disabledTestPaths = [
    "tests/test_ignore.py"
    # These are the main tests but they're fragile so skip them. They error
    # whenever matplotlib outputs any unexpected warnings, e.g. deprecation
    # warnings.
    "tests/test_unit_tests_in_notebooks.py"
    # Impure
    "tests/test_timeouts.py"
    # No value for us
    "tests/test_coverage.py"
    # nbdime marked broken
    "tests/test_nbdime_reporter.py"
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "nbval" ];

  meta = with lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = "https://github.com/computationalmodelling/nbval";
    changelog = "https://github.com/computationalmodelling/nbval/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
