{
  lib,
  bluetooth-data-tools,
  bluetooth-sensor-state-data,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant-bluetooth,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  sensor-state-data,
}:

buildPythonPackage (finalAttrs: {
  pname = "inkbird-ble";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "inkbird-ble";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I07HIbrYXTlaP4TSfyZmEhj1HAjus05JEiPD9UxRatc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "inkbird_ble" ];

  meta = {
    description = "Library for Inkbird BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/inkbird-ble";
    changelog = "https://github.com/Bluetooth-Devices/inkbird-ble/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
