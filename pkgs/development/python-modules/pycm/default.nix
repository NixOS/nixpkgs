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
  version = "3.6";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-96M/QKt4AdiZoZ7L9AHocSyZPkwEb2iuRJKW3rVP3hc=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    seaborn
  ];

  checkInputs = [
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

  disabledTests = [
    # Output formatting error
    "pycm.pycm_compare.Compare"
    "plot_test"
  ];

  pythonImportsCheck = [
    "pycm"
  ];

  meta = with lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.ir";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
