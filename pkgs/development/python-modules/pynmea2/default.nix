{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b94lhpbgvnknb563dlwvs5vkk7w3ma54sj614ynh2dzgqrd6h73";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pynmea2" ];

  meta = {
    homepage = "https://github.com/Knio/pynmea2";
    description = "Python library for the NMEA 0183 protcol";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
