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
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0613drjl740ppam3spm4b8mdcwwvl1lfmqy3vkgznbvzfxfpb3zj";
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
