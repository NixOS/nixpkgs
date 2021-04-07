{ lib
, buildPythonPackage
, fetchPypi
, coverage
, ipykernel
, jupyter_client
, nbformat
, pytest
, six
, glibcLocales
, matplotlib
, sympy
, pytestcov
}:

buildPythonPackage rec {
  pname = "nbval";
  version = "0.9.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfefcd2ef66ee2d337d0b252c6bcec4023384eb32e8b9e5fcc3ac80ab8cd7d40";
  };

  checkInputs = [
    pytest
    matplotlib
    sympy
    pytestcov
  ];

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [
    coverage
    ipykernel
    jupyter_client
    nbformat
    pytest
    six
  ];

  # Set HOME so that matplotlib doesn't try to use
  # /homeless-shelter/.config/matplotlib, otherwise some of the tests fail for
  # having an unexpected warning on stderr produced by matplotlib.
  # Ignore impure tests.
  checkPhase = ''
    export HOME=$(mktemp -d)
    pytest tests --ignore tests/test_timeouts.py
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = "https://github.com/computationalmodelling/nbval";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
