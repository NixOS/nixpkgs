{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, matplotlib, numpy, pytestCheckHook, seaborn }:

buildPythonPackage rec {
  pname = "pycm";
  version = "3.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner  = "sepandhaghighi";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1p2scgb4aghjlxak4zvm3s9ydkpg42mdxy6vjxlnqw0wpnsskfni";
  };

  # remove a trivial dependency on the author's `art` Python ASCII art library
  postPatch = ''
    rm pycm/__main__.py
    rm Otherfiles/notebook_check.py  # also depends on python3Packages.notebook
    substituteInPlace setup.py --replace '=get_requires()' '=[]'
  '';

  checkInputs = [ pytestCheckHook ];
  disabledTests = [ "pycm.pycm_compare.Compare" ];  # output formatting error
  propagatedBuildInputs = [ matplotlib numpy seaborn ];

  meta = with lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.ir";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
