{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "kegtron-ble";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "kegtron-ble";
    tag = "v${version}";
    hash = "sha256-aPWf+EHr6Et4OHJ8ZN9M1NxKhaf7piEQilzAsBO3d5E=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kegtron_ble" ];

  meta = with lib; {
    description = "Library for Kegtron BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/kegtron-ble";
    changelog = "https://github.com/Bluetooth-Devices/kegtron-ble/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
