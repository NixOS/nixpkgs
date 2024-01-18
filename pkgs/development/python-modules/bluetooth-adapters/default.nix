{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, aiohttp
, async-timeout
, bleak
, dbus-fast
, mac-vendor-lookup
, myst-parser
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
, usb-devices
}:

buildPythonPackage rec {
  pname = "bluetooth-adapters";
  version = "0.17.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = "bluetooth-adapters";
    rev = "refs/tags/v${version}";
    hash = "sha256-7j55+bCScoqtYJ/1lmqsPk3j+dbs+VfPTzTiwdVg0Pw=";
  };

  postPatch = ''
    # Drop pytest arguments (coverage, ...)
    sed -i '/addopts/d' pyproject.toml
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    myst-parser
    poetry-core
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    bleak
    dbus-fast
    mac-vendor-lookup
    usb-devices
  ];

  pythonImportsCheck = [
    "bluetooth_adapters"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tools to enumerate and find Bluetooth Adapters";
    homepage = "https://bluetooth-adapters.readthedocs.io/";
    changelog = "https://github.com/bluetooth-devices/bluetooth-adapters/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
