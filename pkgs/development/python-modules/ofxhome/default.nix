{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  version = "0.3.3";
  format = "setuptools";
  pname = "ofxhome";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hRBFH9IowwYnw9GMLlMN81lEr8KkyXyIjfYmLDJ2/uY=";
  };

  buildInputs = [ nose ];

  # ImportError: No module named tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/captin411/ofxhome";
    description = "ofxhome.com financial institution lookup REST client";
    license = licenses.mit;
  };
}
