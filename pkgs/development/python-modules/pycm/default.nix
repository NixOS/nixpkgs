{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, matplotlib, numpy, pytest, seaborn }:

buildPythonPackage rec {
  pname = "pycm";
  version = "3.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner  = "sepandhaghighi";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1aspd3vkjasb4wxs9czwjw42fmd4027wsmm4vlj09yp7sl57gary";
  };

  # remove a trivial dependency on the author's `art` Python ASCII art library
  postPatch = ''
    rm pycm/__main__.py
    substituteInPlace setup.py --replace '=get_requires()' '=[]'
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ matplotlib numpy seaborn ];

  checkPhase = ''
    pytest Test/
  '';

  meta = with lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.ir";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
