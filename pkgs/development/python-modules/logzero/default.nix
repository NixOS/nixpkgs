{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "logzero";
  version = "1.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f3Pd0645NFcjbwgf/r0ESjqi5COkeubdtReauQ0K0II=";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/metachris/logzero";
    description = "Robust and effective logging for Python 2 and 3";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
