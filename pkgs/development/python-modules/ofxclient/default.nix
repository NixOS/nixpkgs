{
  lib,
  buildPythonPackage,
  fetchPypi,
  ofxhome,
  ofxparse,
  beautifulsoup4,
  lxml,
  keyring,
}:

buildPythonPackage rec {
  version = "2.0.3";
  format = "setuptools";
  pname = "ofxclient";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aJTjCyWHngkFAyHlbS4tuwiGCrWaV9OBHdaTQZfGsEk=";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace '"argparse",' ""
  '';

  # ImportError: No module named tests
  doCheck = false;

  propagatedBuildInputs = [
    ofxhome
    ofxparse
    beautifulsoup4
    lxml
    keyring
  ];

  meta = with lib; {
    homepage = "https://github.com/captin411/ofxclient";
    description = "OFX client for dowloading transactions from banks";
    mainProgram = "ofxclient";
    license = licenses.mit;
  };
}
