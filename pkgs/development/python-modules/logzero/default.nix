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
    sha256 = "7f73ddd3ae393457236f081ffebd044a3aa2e423a47ae6ddb5179ab90d0ad082";
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
