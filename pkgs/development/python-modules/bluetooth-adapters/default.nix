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
  pytestCheckHook,
  pythonOlder,
  sphinx-rtd-theme,
  sphinxHook,
  uart-devices,
  usb-devices,
}:

buildPythonPackage rec {
  pname = "bluetooth-adapters";
  version = "0.19.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-adapters";
    rev = "refs/tags/v${version}";
    hash = "sha256-XpPC7FVWzdEki6kdZDu0vV7iD1DZzGbI1f9VKxsjKUQ=";
  };

  postPatch = ''
    # Drop pytest arguments (coverage, ...)
    sed -i '/addopts/d' pyproject.toml
  '';

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    myst-parser
    poetry-core
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

  pythonImportsCheck = [ "bluetooth_adapters" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Tools to enumerate and find Bluetooth Adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-adapters";
    changelog = "https://github.com/bluetooth-devices/bluetooth-adapters/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
