{ lib
<<<<<<< HEAD
=======
, asynctest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildPythonPackage
, click
, fetchFromGitHub
, justbackoff
, pythonOlder
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "nessclient";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "nickw444";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-UqHXKfS4zF1YhFbNKSVESmsxD0CYJKOmjMOE3blGdI8=";
=======
    hash = "sha256-zjUYdSHIMCB4cCAsOOQZ9YgmFTskzlTUs5z/xPFt01Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    justbackoff
    click
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
=======
    asynctest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nessclient"
  ];

  meta = with lib; {
    description = "Python implementation/abstraction of the Ness D8x/D16x Serial Interface ASCII protocol";
    homepage = "https://github.com/nickw444/nessclient";
<<<<<<< HEAD
    changelog = "https://github.com/nickw444/nessclient/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
