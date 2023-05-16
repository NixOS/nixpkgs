{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pexpect
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cpyparsing";
<<<<<<< HEAD
  version = "2.4.7.2.1.2";
=======
  version = "2.4.7.1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Y3EyX9Gjssez0DkD6dIaOpazNLy7rDYzjKO1u+lLGFI=";
  };

  nativeBuildInputs = [
    cython
  ];

  nativeCheckInputs = [
    pexpect
  ];
=======
    hash = "sha256-cb0Lx+S9WnPa9veHJaYEU7pFCtB6pG/GKf4HK/UbmtU=";
  };

  nativeBuildInputs = [ cython ];

  nativeCheckInputs = [ pexpect ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkPhase = ''
    ${python.interpreter} tests/cPyparsing_test.py
  '';

  pythonImportsCheck = [
    "cPyparsing"
  ];

  meta = with lib; {
    description = "Cython PyParsing implementation";
    homepage = "https://github.com/evhub/cpyparsing";
<<<<<<< HEAD
    changelog = "https://github.com/evhub/cpyparsing/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
