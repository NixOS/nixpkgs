{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  scapy,

  # tests
  blockbuster,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiodhcpwatcher";
  version = "1.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "aiodhcpwatcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a6svFLu0nmVVVVCg/evdmygTPj8VP+mjKTaaZGA0TQk=";
  };

  build-system = [ poetry-core ];

  dependencies = [ scapy ];

  nativeCheckInputs = [
    blockbuster
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "aiodhcpwatcher" ];

  meta = {
    description = "Watch for DHCP packets with asyncio";
    homepage = "https://github.com/Bluetooth-Devices/aiodhcpwatcher";
    changelog = "https://github.com/Bluetooth-Devices/aiodhcpwatcher/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    platforms = lib.platforms.linux;
  };
})
