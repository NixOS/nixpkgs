{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynmea2";
  version = "1.19.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hap5uTJ5+IfRwjXlzFx54yZEVkE4zkaYmrD0ovyXDXw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pynmea2"
  ];

  meta = {
    description = "Python library for the NMEA 0183 protcol";
    homepage = "https://github.com/Knio/pynmea2";
    changelog = "https://github.com/Knio/pynmea2/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
