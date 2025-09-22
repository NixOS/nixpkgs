{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "govee-ble";
  version = "0.45.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "govee-ble";
    tag = "v${version}";
    hash = "sha256-SUxK4H0Vo8C4GykIv8duFhhiGBA860QofVQDO37Ubdw=";
  };

  build-system = [ poetry-core ];

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

  pythonImportsCheck = [ "govee_ble" ];

  meta = with lib; {
    description = "Library for Govee BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/govee-ble";
    changelog = "https://github.com/bluetooth-devices/govee-ble/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
