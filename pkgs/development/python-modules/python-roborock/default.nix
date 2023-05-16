{ lib
<<<<<<< HEAD
, stdenv
, aiohttp
, alexapy
=======
, aiohttp
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, async-timeout
, buildPythonPackage
, click
, construct
, dacite
, fetchFromGitHub
, paho-mqtt
, poetry-core
, pycryptodome
<<<<<<< HEAD
, pycryptodomex
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
=======
, pytest-asyncio
, pytestCheckHook
, pythonOlder
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "python-roborock";
<<<<<<< HEAD
  version = "0.33.2";
  format = "pyproject";

  disabled = pythonOlder "3.10";
=======
  version = "0.17.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "humbertogontijo";
    repo = "python-roborock";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-UAQlKfh6oljeWtEGYx7JiT1z9yFCAXRSlI4Ot6JUnoQ=";
  };

  pythonRelaxDeps = [
    "pycryptodome"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    alexapy
=======
    hash = "sha256-lDSIed+/n/3D2kI44FcTbcTl9xAl+EbCPGrhfN5q4JE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    aiohttp
    async-timeout
    click
    construct
    dacite
    paho-mqtt
    pycryptodome
<<<<<<< HEAD
  ] ++ lib.optionals stdenv.isDarwin [
    pycryptodomex
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "roborock"
  ];

  meta = with lib; {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/humbertogontijo/python-roborock";
    changelog = "https://github.com/humbertogontijo/python-roborock/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
