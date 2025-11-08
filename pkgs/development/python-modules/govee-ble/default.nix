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
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "govee-ble";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "govee-ble";
    tag = "v${version}";
    hash = "sha256-CYxPb5v7T+sp+2HJojGEVPIIaC0ySobiSK8qtHeuv7s=";
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

  meta = {
    description = "Library for Govee BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/govee-ble";
    changelog = "https://github.com/bluetooth-devices/govee-ble/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
