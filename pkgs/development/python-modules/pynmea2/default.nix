{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w9g5qh573276404f04b46684ydlakv30ds0x0r4kcl370ljmfsg";
  };

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/Knio/pynmea2";
    description = "Python library for the NMEA 0183 protcol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
