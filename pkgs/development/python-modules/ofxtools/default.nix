{ stdenv
, buildPythonPackage
, fetchFromGitHub
, nose
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.8.20";

  disabled = pythonOlder "3.7";

  # PyPI distribution does not include tests
  src = fetchFromGitHub {
    owner = "csingley";
    repo = pname;
    rev = version;
    sha256 = "1s3fhhmj1acnmqglh39003db0bi451m4hcrkcpyrkqf5m32lslz8";
  };

  checkInputs = [ nose ];
  # override $HOME directory:
  #   error: [Errno 13] Permission denied: '/homeless-shelter'
  checkPhase = ''
    HOME=$TMPDIR nosetests tests/*.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/csingley/ofxtools";
    description = "Library for working with Open Financial Exchange (OFX) formatted data used by financial institutions";
    license = licenses.mit;
  };
}
