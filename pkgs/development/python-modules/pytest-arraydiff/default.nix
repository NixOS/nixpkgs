{ lib, buildPythonPackage, fetchPypi, python, numpy, six, pytest }:

buildPythonPackage rec {
  pname = "pytest-arraydiff";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0145edfa8830aba07150fc09443da74d0ec4074e3de702445453415a744d3ad9";
  };

  propagatedBuildInputs = [ numpy six pytest ];

  checkPhase = ''
    ${python.interpreter} -c 'import pytest_arraydiff.plugin'
    # The remaining tests depend on astropy, which in turn depends on pytest-arraydiff
    # pytest -vv --arraydiff --cov pytest_arraydiff tests
    # pytest -vv --cov pytest_arraydiff --cov-append tests
  '';

  meta = with lib; {
    description = "Pytest plugin to help with comparing array output from tests";
    homepage = https://github.com/astrofrog/pytest-arraydiff;
    license = licenses.bsd2;
  };
}
