{
  lib,
  async-timeout,
  bluetooth-adapters,
  btsocket,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyric,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  usb-devices,
}:

buildPythonPackage rec {
  pname = "bluetooth-auto-recovery";
  version = "1.4.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-auto-recovery";
    tag = "v${version}";
    hash = "sha256-Sm3VLgWttMVXH+s1m1ab8kE6dHPit0GY4FVAld5Yg88=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-timeout
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

  meta = with lib; {
    description = "Library for recovering Bluetooth adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
