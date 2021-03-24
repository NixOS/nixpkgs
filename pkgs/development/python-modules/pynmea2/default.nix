{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d415c586bf2f40aebf452d62105528428806a5333321bfcdcfadf16caccbd74";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/Knio/pynmea2";
    description = "Python library for the NMEA 0183 protcol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
