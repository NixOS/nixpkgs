{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, future
, numpy
, scipy
, matplotlib
, scikit-learn
, torch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ezyrb";
<<<<<<< HEAD
  version = "1.3.0.post2305";
=======
  version = "1.3.0.post2302";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "EZyRB";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-uYwLz5NY+8lO8hZnAhqv+5PlcCSm6OOFWra47pwQhxg=";
=======
    hash = "sha256-ZVmQnxqLHKr275Xx0lOID3BZZFTmn/PMHpYhBFSxT7I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    future
    numpy
    scipy
    matplotlib
    scikit-learn
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ezyrb"
  ];

  disabledTestPaths = [
    # Exclude long tests
    "tests/test_podae.py"
  ];

  meta = with lib; {
    description = "Easy Reduced Basis method";
    homepage = "https://mathlab.github.io/EZyRB/";
    downloadPage = "https://github.com/mathLab/EZyRB/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
  };
}
