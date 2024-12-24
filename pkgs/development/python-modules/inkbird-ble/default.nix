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
  pname = "inkbird-ble";
  version = "0.5.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "inkbird-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-cUqU4XaY7CORhzy0AGjXI5c5ka+PnF4cHdyopyEBcLo=";
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

  pythonImportsCheck = [ "inkbird_ble" ];

  meta = with lib; {
    description = "Library for Inkbird BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/inkbird-ble";
    changelog = "https://github.com/Bluetooth-Devices/inkbird-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
