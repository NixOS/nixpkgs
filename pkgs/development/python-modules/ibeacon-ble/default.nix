{
  lib,
  aiohttp,
  aiooui,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  mac-vendor-lookup,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ibeacon-ble";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "ibeacon-ble";
    tag = "v${version}";
    hash = "sha256-1liSWxduYpjIMu7226EH4bsc7gca5g/fyL79W4ZMdU4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiooui
    home-assistant-bluetooth
    mac-vendor-lookup
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ibeacon_ble" ];

  meta = with lib; {
    description = "Library for iBeacon BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/ibeacon-ble";
    changelog = "https://github.com/Bluetooth-Devices/ibeacon-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
