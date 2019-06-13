{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "logzero";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hli2wgwxxackrk1ybmlpdd0rzms6blm11zzwlvrzykd8cp1xyil";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = https://github.com/metachris/logzero;
    description = "Robust and effective logging for Python 2 and 3";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
