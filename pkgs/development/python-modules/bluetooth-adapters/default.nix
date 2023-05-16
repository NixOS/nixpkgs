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
<<<<<<< HEAD
  version = "0.16.1";
=======
  version = "0.15.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-GJhrL6J/L1+tqa7fN5xwE+8IFZZ9kff2g+04H5M7beY=";
=======
    hash = "sha256-H8QkOs+QPN9jB/g4f3OaGlX/F2SO2hIDptoPB47ogqA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
