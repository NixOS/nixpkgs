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
  version = "0.16.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gbnsTRiT/4YumyaJ1h4VRzDAf8/oSkD3yL9mdACvWWk=";
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
