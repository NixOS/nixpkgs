{ lib
, async-timeout
<<<<<<< HEAD
, bluetooth-adapters
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, btsocket
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pyric
, pytestCheckHook
, pythonOlder
, usb-devices
}:

buildPythonPackage rec {
  pname = "bluetooth-auto-recovery";
<<<<<<< HEAD
  version = "1.2.3";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-1ytiTIAV00Wk2zqZKRAsstVLuyzPEGBISz0g0ssC5Eo=";
=======
    hash = "sha256-uPa8iXG++doRMAK83NSnqiqnZSIjdL7zMTkjdRrSjtA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-timeout
<<<<<<< HEAD
    bluetooth-adapters
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    btsocket
    pyric
    usb-devices
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bluetooth_auto_recovery --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bluetooth_auto_recovery"
  ];

  meta = with lib; {
    description = "Library for recovering Bluetooth adapters";
    homepage = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery";
    changelog = "https://github.com/Bluetooth-Devices/bluetooth-auto-recovery/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
