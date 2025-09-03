{
  lib,
  aiohttp,
  aiooui,
  async-timeout,
  bleak,
  buildPythonPackage,
  dbus-fast,
  fetchFromGitHub,
  mac-vendor-lookup,
  myst-parser,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  sphinx-rtd-theme,
  sphinxHook,
  uart-devices,
  usb-devices,
}:

buildPythonPackage rec {
  pname = "bluetooth-adapters";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-adapters";
    tag = "v${version}";
    hash = "sha256-euAyVSBmlMsPMUnxn8L7p0n939TQe4id+JTtUk4pHIY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    poetry-core
  ];

  nativeBuildInputs = [
    myst-parser
    sphinx-rtd-theme
    sphinxHook
  ];

  dependencies = [
    aiohttp
    aiooui
    async-timeout
    bleak
    dbus-fast
    mac-vendor-lookup
    uart-devices
    usb-devices
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bluetooth_adapters" ];

  meta = {
    description = "Tools to enumerate and find Bluetooth Adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-adapters";
    changelog = "https://github.com/bluetooth-devices/bluetooth-adapters/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
