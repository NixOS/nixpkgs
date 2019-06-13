{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b83fa7e3e668af5e182ef1c2fd4a535433ecadf60d7b627280172d695a1646b";
  };

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = {
    homepage = https://github.com/Knio/pynmea2;
    description = "Python library for the NMEA 0183 protcol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ geistesk ];
  };
}
