{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x5xrk51dpzsvky1ncikadm80a44a82j3mjjykmhmx7jddc5qh9d";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/Knio/pynmea2";
    description = "Python library for the NMEA 0183 protcol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
