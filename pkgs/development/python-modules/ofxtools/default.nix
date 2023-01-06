{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.9.5";

  disabled = pythonOlder "3.8";

  # PyPI distribution does not include tests
  src = fetchFromGitHub {
    owner = "csingley";
    repo = pname;
    rev = version;
    sha256 = "sha256-NsImnD+erhpakQnl1neuHfSKiV6ipNBMPGKMDM0gwWc=";
  };

  checkInputs = [ nose ];
  # override $HOME directory:
  #   error: [Errno 13] Permission denied: '/homeless-shelter'
  checkPhase = ''
    HOME=$TMPDIR nosetests tests/*.py
  '';

  meta = with lib; {
    homepage = "https://github.com/csingley/ofxtools";
    description = "Library for working with Open Financial Exchange (OFX) formatted data used by financial institutions";
    license = licenses.mit;
  };
}
