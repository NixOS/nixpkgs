{
  lib,
  bleak,
  bleak-retry-connector,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "oralb-ble";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "oralb-ble";
    tag = "v${version}";
    hash = "sha256-2uXfsWt8MW/neeh2HR59u0jOVXwjt4IM2DGR+vuvi2c=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bleak
    bleak-retry-connector
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "oralb_ble" ];

  disabledTests = [
    # Test is outdated, TypeError: BLEDevice.__init__() missing 2 required...
    "test_async_poll"
  ];

  meta = with lib; {
    description = "Library for Oral B BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/oralb-ble";
    changelog = "https://github.com/Bluetooth-Devices/oralb-ble/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
