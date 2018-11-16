{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "185wxn8gag9whxmysspbh8s7wn3sh1glgf508w2zzwi4lklryl7i";
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
