{ lib
, buildPythonPackage
, fetchFromGitHub
, cons
, multipledispatch
, py
, pytestCheckHook
, pytest-html
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "etuples";
<<<<<<< HEAD
  version = "0.3.9";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pythological";
    repo = "etuples";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-dl+exar98PnqEiCNX+Ydllp7aohsAYrFtxb2Q1Lxx6Y=";
=======
    hash = "sha256-wEgam2IoI3z75bN45/R9o+0JmL3g0YmtsuJ4TnZjhi8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cons
    multipledispatch
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

<<<<<<< HEAD
  pythonImportsCheck = [
    "etuples"
  ];
=======
  pythonImportsCheck = [ "etuples" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python S-expression emulation using tuple-like objects";
    homepage = "https://github.com/pythological/etuples";
<<<<<<< HEAD
    changelog = "https://github.com/pythological/etuples/releases/tag/v${version}";
=======
    changelog = "https://github.com/pythological/etuples/releases";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ Etjean ];
  };
}
