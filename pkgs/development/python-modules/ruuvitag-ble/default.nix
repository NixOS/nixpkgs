{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  home-assistant-bluetooth,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "ruuvitag-ble";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "ruuvitag-ble";
    tag = "v${version}";
    hash = "sha256-9aaAKb5Av2OMDGaSM9+tT0s++YYE0g1D01Le6RrMoMk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ruuvitag_ble" ];

  meta = with lib; {
    description = "Library for Ruuvitag BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/ruuvitag-ble";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
