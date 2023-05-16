{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, aioresponses
<<<<<<< HEAD
, orjson
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bond-async";
<<<<<<< HEAD
  version = "0.2.1";
=======
  version = "0.1.23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bondhome";
    repo = "bond-async";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-YRJHUOYFLf4dtQGIFKHLdUQxWTnZzG1MPirMsGvDor8=";
=======
    hash = "sha256-Kht2O/+F7Nw78p1Q6NGugm2bfAwZAUWAs30htoWkafI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
<<<<<<< HEAD
    orjson
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bond_async"
  ];

<<<<<<< HEAD
  meta = with lib; {
    description = "Asynchronous Python wrapper library over Bond Local API";
    homepage = "https://github.com/bondhome/bond-async";
    changelog = "https://github.com/bondhome/bond-async/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
=======
  meta = {
    description = "Asynchronous Python wrapper library over Bond Local API";
    homepage = "https://github.com/bondhome/bond-async";
    changelog = "https://github.com/bondhome/bond-async/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
