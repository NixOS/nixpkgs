{ lib
, buildPythonPackage
, fetchFromGitHub
, logical-unification
, py
, pytestCheckHook
, pytest-html
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cons";
<<<<<<< HEAD
  version = "0.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "python-cons";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-XssERKiv4A8x7dZhLeFSciN6RCEfGs0or3PAQiYSPII=";
=======
    rev = "fbeedfc8a3d1bff4ba179d492155cdd55538365e";
    hash = "sha256-ivHFep9iYPvyiBIZKMAzqrLGnQkeuxd0meYMZwZFFH0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    logical-unification
  ];

  nativeCheckInputs = [
    py
    pytestCheckHook
    pytest-html
  ];

  pytestFlagsArray = [
    "--html=testing-report.html"
    "--self-contained-html"
  ];

  pythonImportsCheck = [ "cons" ];

  meta = with lib; {
    description = "An implementation of Lisp/Scheme-like cons in Python";
    homepage = "https://github.com/pythological/python-cons";
<<<<<<< HEAD
    changelog = "https://github.com/pythological/python-cons/releases/tag/v${version}";
=======
    changelog = "https://github.com/pythological/python-cons/releases";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Etjean ];
  };
}
