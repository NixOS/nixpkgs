{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "logzero";
  version = "1.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1435284574e409b8ec8b680f276bca04cab41f93d6eff4dc8348b7630cddf560";
  };

  checkInputs = [ pytest ];
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
