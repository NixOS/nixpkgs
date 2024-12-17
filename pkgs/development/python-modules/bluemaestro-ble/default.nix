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
  pname = "bluemaestro-ble";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluemaestro-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-mJ5JNGN4F9U3WMJQDwiZwuxE0zOirwo1sWF3/bVwXhY=";
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

  pythonImportsCheck = [ "bluemaestro_ble" ];

  meta = with lib; {
    description = "Library for bluemaestro BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/bluemaestro-ble";
    changelog = "https://github.com/Bluetooth-Devices/bluemaestro-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
