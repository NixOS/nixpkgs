{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytest-asyncio
, pytestCheckHook
, pythonOlder
=======
, asynctest
, pytest-asyncio
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "dynalite-devices";
<<<<<<< HEAD
  version = "0.1.48";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.47";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ziv1234";
    repo = "python-dynalite-devices";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-i88aIsRNsToSceQdwfspJg+Y5MO5zC4O6EkyhrYR27g=";
=======
    rev = "refs/tags/v${version}"; # https://github.com/ziv1234/python-dynalite-devices/issues/2
    hash = "sha256-kJo4e5vhgWzijLUhQd9VBVk1URpg9SXhOA60dJYashM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i '/^addopts/d' setup.cfg
  '';

  nativeCheckInputs = [
<<<<<<< HEAD
=======
    asynctest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "dynalite_devices_lib"
  ];
=======
  pythonImportsCheck = [ "dynalite_devices_lib" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An unofficial Dynalite DyNET interface creating devices";
    homepage = "https://github.com/ziv1234/python-dynalite-devices";
<<<<<<< HEAD
    changelog = "https://github.com/ziv1234/python-dynalite-devices/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
