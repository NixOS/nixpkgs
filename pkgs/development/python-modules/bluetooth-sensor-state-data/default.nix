{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "bluetooth-sensor-state-data";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-sensor-state-data";
    tag = "v${version}";
    hash = "sha256-V7stHAID6zkLFYDX5HUVF38/8OHa4AZr48FPmSoDcAE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bluetooth_sensor_state_data" ];

  meta = {
    description = "Models for storing and converting Bluetooth Sensor State Data";
    homepage = "https://github.com/bluetooth-devices/bluetooth-sensor-state-data";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-sensor-state-data/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
