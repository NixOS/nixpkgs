{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "autocommand";
<<<<<<< HEAD
  version = "2.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "2.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Lucretiel";
    repo = "autocommand";
<<<<<<< HEAD
    rev = "refs/tags/${version}";
    hash = "sha256-9bv9Agj4RpeyNJvTLUaMwygQld2iZZkoLb81rkXOd3E=";
=======
    rev = version;
    hash = "sha256-bjoVGfP57qhvPuHHcMP8JQddAaW4/fEyatElk1UEPZo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # fails with: SyntaxError: invalid syntax
  doCheck = false;

<<<<<<< HEAD
  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autocommand"
  ];

  meta = with lib; {
    description = "Autocommand turns a python function into a CLI program";
    homepage = "https://github.com/Lucretiel/autocommand";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
=======
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "autocommand" ];

  meta = with lib; {
    description = " Autocommand turns a python function into a CLI program ";
    homepage = "https://github.com/Lucretiel/autocommand";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
