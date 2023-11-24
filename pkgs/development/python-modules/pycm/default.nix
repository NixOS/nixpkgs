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
  version = "4.0";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GyH06G7bArFBTzV/Sx/KmoJvcoed0sswW7qGqsSULHo=";
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
