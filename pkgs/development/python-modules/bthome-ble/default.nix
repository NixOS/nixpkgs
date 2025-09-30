{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pytz,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "bthome-ble";
  version = "3.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bthome-ble";
    tag = "v${version}";
    hash = "sha256-kxKQnHrRZE7ugrRn7VSwQ99TtEX/DmH5x4Yy22UsXjA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    cryptography
    sensor-state-data
    pytz
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bthome_ble" ];

  meta = with lib; {
    description = "Library for BThome BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/bthome-ble";
    changelog = "https://github.com/bluetooth-devices/bthome-ble/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
