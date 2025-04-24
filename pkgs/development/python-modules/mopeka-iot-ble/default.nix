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
  pname = "mopeka-iot-ble";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "mopeka-iot-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-CKLC0p66JapE9qNePE11ttoGMVd4kA7g28kA+pYLXCE=";
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

  meta = with lib; {
    description = "Library for Mopeka IoT BLE devices";
    homepage = "https://github.com/bluetooth-devices/mopeka-iot-ble";
    changelog = "https://github.com/Bluetooth-Devices/mopeka-iot-ble/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
