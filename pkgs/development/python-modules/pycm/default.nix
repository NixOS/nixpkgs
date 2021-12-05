{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, matplotlib, numpy
, pytestCheckHook, seaborn }:

buildPythonPackage rec {
  pname = "pycm";
  version = "3.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i3qpb20mnc22qny1ar3yvxb1dac7njwi8bvi5sy5kywz10c5dkw";
  };

  # remove a trivial dependency on the author's `art` Python ASCII art library
  postPatch = ''
    rm pycm/__main__.py
    rm Otherfiles/notebook_check.py  # also depends on python3Packages.notebook
    substituteInPlace setup.py --replace '=get_requires()' '=[]'
  '';

  checkInputs = [ pytestCheckHook ];
  disabledTests = [ "pycm.pycm_compare.Compare" ]; # output formatting error
  propagatedBuildInputs = [ matplotlib numpy seaborn ];

  meta = with lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.ir";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
