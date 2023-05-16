{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
<<<<<<< HEAD
, cryptography
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
=======
, fetchFromGitHub
, poetry-core
, pycryptodomex
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "bthome-ble";
<<<<<<< HEAD
  version = "3.1.1";
=======
  version = "2.11.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
<<<<<<< HEAD
    repo = "bthome-ble";
    rev = "refs/tags/v${version}";
    hash = "sha256-fQIvOa9/Bqo4BN6LJz8COHo6n2m4XogVYCMdAUvDZUQ=";
=======
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-U0R4WWgXtfP1vvrGdJl70xO88YhvxwJYDnMiN4B+Waw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
<<<<<<< HEAD
    cryptography
    sensor-state-data
    pytz
=======
    sensor-state-data
    pycryptodomex
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=bthome_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "bthome_ble"
  ];

  meta = with lib; {
    description = "Library for BThome BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/bthome-ble";
    changelog = "https://github.com/bluetooth-devices/bthome-ble/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
