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
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-adapters";
    tag = "v${version}";
    hash = "sha256-M9Me+fTaw//wGVd9Ss9iYB7RMgfkxJZz2lT60lHe3Vg=";
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
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-adapters/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.home-assistant ];
  };
}
