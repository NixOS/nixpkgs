 { lib
, aiohttp
, async-timeout
, buildPythonPackage
, crcmod
, defusedxml
, fetchFromGitHub
, freezegun
, jsonpickle
, munch
<<<<<<< HEAD
=======
, mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyserial
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, semver
}:

buildPythonPackage rec {
  pname = "plugwise";
<<<<<<< HEAD
  version = "0.32.2";
=======
  version = "0.31.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = "python-plugwise";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-kJ7HbGwmA6/OtSxpkvajf+VzjYK+uq6kMaja9CmVBt4=";
=======
    hash = "sha256-lxeOGNO5OF4lLIQf/7TrrF091RKjdq8k80bBA/v5O4A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    crcmod
    defusedxml
    munch
    pyserial
    python-dateutil
    pytz
    semver
  ];

  nativeCheckInputs = [
    freezegun
    jsonpickle
<<<<<<< HEAD
=======
    mypy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "plugwise"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python module for Plugwise Smiles, Stretch and USB stick";
    homepage = "https://github.com/plugwise/python-plugwise";
    changelog = "https://github.com/plugwise/python-plugwise/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
