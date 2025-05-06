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
  pythonOlder,
  pytz,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "bthome-ble";
  version = "3.12.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bthome-ble";
    tag = "v${version}";
    hash = "sha256-SuGmNcx+z/4GOxgAsupY7NW+2ni7vLaAEC3EKn6ctpw=";
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
