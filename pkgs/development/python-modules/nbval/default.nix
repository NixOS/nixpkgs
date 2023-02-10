{ lib
, buildPythonPackage
, fetchPypi
, coverage
, ipykernel
, jupyter-client
, nbformat
, pytestCheckHook
, pytest
, six
, glibcLocales
, matplotlib
, sympy
}:

buildPythonPackage rec {
  pname = "nbval";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfefcd2ef66ee2d337d0b252c6bcec4023384eb32e8b9e5fcc3ac80ab8cd7d40";
  };

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    coverage
    ipykernel
    jupyter-client
    nbformat
    pytest
    six
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
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "nbval"
  ];

  meta = with lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = "https://github.com/computationalmodelling/nbval";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
