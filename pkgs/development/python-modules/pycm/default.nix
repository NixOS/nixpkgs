{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, numpy, pytest }:

buildPythonPackage rec {
  pname = "pycm";
  version = "2.9";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner  = "sepandhaghighi";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "181v4rdnblxpqq8rhnm2qdfh033a7sig1z2yz8yb93ypidj14hnk";
  };

  # remove a trivial dependency on the author's `art` Python ASCII art library
  postPatch = ''
    rm pycm/__main__.py
    substituteInPlace setup.py --replace '=get_requires()' '=[]'
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy ];

  checkPhase = ''
    pytest Test/
  '';

  meta = with stdenv.lib; {
    description = "Multiclass confusion matrix library";
    homepage = "https://pycm.ir";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
