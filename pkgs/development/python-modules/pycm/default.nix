{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, pytestCheckHook
, pythonOlder
, seaborn
}:

buildPythonPackage rec {
  pname = "pycm";
<<<<<<< HEAD
  version = "4.0";
=======
  version = "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-GyH06G7bArFBTzV/Sx/KmoJvcoed0sswW7qGqsSULHo=";
=======
    hash = "sha256-L0WPZomOU/I/x8QrdAerG0S2wnHyP661XTaDzzWeruk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    seaborn
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # Remove a trivial dependency on the author's `art` Python ASCII art library
    rm pycm/__main__.py
    # Also depends on python3Packages.notebook
    rm Otherfiles/notebook_check.py
    substituteInPlace setup.py \
      --replace '=get_requires()' '=[]'
  '';

  # https://github.com/sepandhaghighi/pycm/issues/488
  pytestFlagsArray = [ "Test" ];

  pythonImportsCheck = [
    "pycm"
  ];

  meta = with lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.io";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
