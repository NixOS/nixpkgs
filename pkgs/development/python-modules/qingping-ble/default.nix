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
  pname = "qingping-ble";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "qingping-ble";
    tag = "v${version}";
    hash = "sha256-74cTx3BSltrBUjN9qY9NBhXqKwcyitkJr+jf6jbzS+Y=";
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

  pythonImportsCheck = [ "qingping_ble" ];

  meta = {
    description = "Library for Qingping BLE devices";
    homepage = "https://github.com/bluetooth-devices/qingping-ble";
    changelog = "https://github.com/Bluetooth-Devices/qingping-ble/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
