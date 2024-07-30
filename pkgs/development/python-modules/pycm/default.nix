{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pytestCheckHook,
  pythonOlder,
  seaborn,
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

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Minor tolerance issues with Python 3.12; should be fixed in next release
    # (see https://github.com/sepandhaghighi/pycm/pull/528)
    "verified_test"
    "function_test"
  ];

  postPatch = ''
    # Remove a trivial dependency on the author's `art` Python ASCII art library
    rm pycm/__main__.py
    # Also depends on python3Packages.notebook
    rm Otherfiles/notebook_check.py
    substituteInPlace setup.py \
      --replace-fail '=get_requires()' '=[]'
  '';

  pythonImportsCheck = [ "pycm" ];

  meta = with lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.io";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
