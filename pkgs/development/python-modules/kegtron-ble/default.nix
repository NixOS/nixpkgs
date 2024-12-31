{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sensor-state-data,
}:

buildPythonPackage rec {
  pname = "kegtron-ble";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "kegtron-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-O5I5shW8nL2RAQptS2Bp/GI/4L6o0xXXmwYvRq0MM8o=";
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
    changelog = "https://github.com/Bluetooth-Devices/kegtron-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
