{ lib
, buildPythonPackage
, fetchFromGitHub
, eth-utils
, hypothesis
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hexbytes";
<<<<<<< HEAD
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.3.0";
  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "hexbytes";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-19oY/VPP6qkxHCkIgpC28fOOYKEYcNbVVGoHJmMmOl8=";
=======
    rev = "v${version}";
    hash = "sha256-EDFE5MUc+XMwe8BaXkz/DRchAZbS86X+AcShi5rx83M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    eth-utils
    hypothesis
    pytestCheckHook
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "hexbytes"
  ];
=======
  pythonImportsCheck = [ "hexbytes" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "`bytes` subclass that decodes hex, with a readable console output";
    homepage = "https://github.com/ethereum/hexbytes";
<<<<<<< HEAD
    changelog = "https://github.com/ethereum/hexbytes/blob/v${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
