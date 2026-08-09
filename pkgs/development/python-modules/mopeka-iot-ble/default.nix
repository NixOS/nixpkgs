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
  pname = "mopeka-iot-ble";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "mopeka-iot-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+iKeh/zt4dUAPGt6aGStjfnF0m6WLRRW1EsWvCJ1Jhw=";
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

  pythonImportsCheck = [ "mopeka_iot_ble" ];

  meta = {
    description = "Library for Mopeka IoT BLE devices";
    homepage = "https://github.com/bluetooth-devices/mopeka-iot-ble";
    changelog = "https://github.com/Bluetooth-Devices/mopeka-iot-ble/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
