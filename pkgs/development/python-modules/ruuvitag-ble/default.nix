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
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "ruuvitag-ble";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "ruuvitag-ble";
    tag = "v${version}";
    hash = "sha256-5hlO2/YCTc65ImwjJVyWhFe2PTPlQ33aNdqEIxH/lms=";
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

  meta = {
    changelog = "https://github.com/Bluetooth-Devices/ruuvitag-ble/releases/tag/${src.tag}";
    description = "Library for Ruuvitag BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/ruuvitag-ble";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
