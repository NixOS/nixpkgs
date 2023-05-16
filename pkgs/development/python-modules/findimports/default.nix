{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "findimports";
<<<<<<< HEAD
  version = "2.3.0";
=======
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mgedmin";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-yA1foeGhgOXZArc/nZfS1tbGyONXJZ9lW+Zcx7hCedM=";
=======
    rev = version;
    hash = "sha256-p13GVDXDOzOiTnRgtF7UxN1vwZRMa7wVEXJQrFQV7RU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  pythonImportsCheck = [
    "findimports"
  ];

  checkPhase = ''
<<<<<<< HEAD
    # Tests fails
    rm tests/cmdline.txt

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook preCheck
    ${python.interpreter} testsuite.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Module for the analysis of Python import statements";
    homepage = "https://github.com/mgedmin/findimports";
<<<<<<< HEAD
    changelog = "https://github.com/mgedmin/findimports/blob/${version}/CHANGES.rst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ gpl2Only /* or */ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
