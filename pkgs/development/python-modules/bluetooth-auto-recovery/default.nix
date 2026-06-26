{
  lib,
  bluetooth-adapters,
  btsocket,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyric,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  usb-devices,
}:

buildPythonPackage (finalAttrs: {
  pname = "bluetooth-auto-recovery";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-auto-recovery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fb83M2V4q4ncmIIMM6BhNDBg8DSjBmYNE+4Qj22wTEE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    bluetooth-adapters
    btsocket
    pyric
    usb-devices
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bluetooth_auto_recovery" ];

  meta = {
    description = "Library for recovering Bluetooth adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
