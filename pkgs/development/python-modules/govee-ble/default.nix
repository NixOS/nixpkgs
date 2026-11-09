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

buildPythonPackage (finalAttrs: {
  pname = "govee-ble";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "govee-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y1iSU6G/+0qSLgFQNKeCuhpVv6mJYXivk0wNGNMBd6U=";
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
    changelog = "https://github.com/bluetooth-devices/govee-ble/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
