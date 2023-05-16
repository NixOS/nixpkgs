{ lib
, bluetooth-data-tools
, bluetooth-sensor-state-data
, buildPythonPackage
, fetchFromGitHub
, hatchling
, home-assistant-bluetooth
, pytestCheckHook
, pythonOlder
, sensor-state-data
}:

buildPythonPackage rec {
  pname = "ruuvitag-ble";
<<<<<<< HEAD
  version = "0.1.2";
=======
  version = "0.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-J+807p2mE+VZ0oqldFtjdcNGsRTkAU54s6byQSGrng4=";
=======
    hash = "sha256-WkPYlEkUH1xvGjBVr6JkLx5CfIPvAa9vX50OjCOmTME=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    bluetooth-data-tools
    bluetooth-sensor-state-data
    home-assistant-bluetooth
    sensor-state-data
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=ruuvitag_ble --cov-report=term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "ruuvitag_ble"
  ];

  meta = with lib; {
    description = "Library for Ruuvitag BLE devices";
    homepage = "https://github.com/Bluetooth-Devices/ruuvitag-ble";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
