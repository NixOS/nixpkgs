{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  flux-led,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "led-ble";
  version = "1.1.7";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "led-ble";
    tag = "v${version}";
    hash = "sha256-6vQPsZvBvoLlxzgfnvjnUdkN24tpBZHr62AFcy3s4gE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    bleak-retry-connector
    flux-led
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "led_ble" ];

  meta = with lib; {
    description = "Library for LED BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/led-ble";
    changelog = "https://github.com/Bluetooth-Devices/led-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
