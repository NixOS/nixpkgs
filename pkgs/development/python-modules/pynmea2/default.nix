{ lib, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.19.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hap5uTJ5+IfRwjXlzFx54yZEVkE4zkaYmrD0ovyXDXw=";
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
