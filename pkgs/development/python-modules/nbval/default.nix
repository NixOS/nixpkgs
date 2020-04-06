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
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xh2p7g5s5g06caaraf3dsz69bpj7dgw2h3ss67kci789aspnwp8";
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

  # ignore impure tests
  checkPhase = ''
    pytest tests --ignore tests/test_timeouts.py
  '';

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = https://github.com/computationalmodelling/nbval;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
