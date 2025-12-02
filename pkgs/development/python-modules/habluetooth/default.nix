{
  lib,
  async-interrupt,
  bleak-retry-connector,
  bleak,
  bluetooth-adapters,
  bluetooth-auto-recovery,
  bluetooth-data-tools,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  freezegun,
  poetry-core,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "habluetooth";
  version = "5.8.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "habluetooth";
    tag = "v${version}";
    hash = "sha256-VbD4fAOZtDtPIGGYb3ISP7c9YLBXAXeOIICqf9Pm5ho=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [
    async-interrupt
    bleak
    bleak-retry-connector
    bluetooth-adapters
    bluetooth-auto-recovery
    bluetooth-data-tools
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "habluetooth" ];

  meta = with lib; {
    description = "Library for high availability Bluetooth";
    homepage = "https://github.com/Bluetooth-Devices/habluetooth";
    changelog = "https://github.com/Bluetooth-Devices/habluetooth/blob/${src.tag}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
