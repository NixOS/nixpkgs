{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, netifaces
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rns";
<<<<<<< HEAD
  version = "0.5.7";
=======
  version = "0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "Reticulum";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-0WNgJKhxK4WjYQ0n7ofqrRxf4m9uWn2ygcZiv3uhrhM=";
=======
    hash = "sha256-yVjbYmvE6b9NZI0JYuMFjU+lh4l8Hf+pF+I/7sQNjVI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cryptography
    netifaces
    pyserial
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "RNS"
  ];

  meta = with lib; {
    description = "Cryptography-based networking stack for wide-area networks";
    homepage = "https://github.com/markqvist/Reticulum";
    changelog = "https://github.com/markqvist/Reticulum/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
