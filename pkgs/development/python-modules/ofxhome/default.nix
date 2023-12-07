{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  version = "0.3.3";
  format = "setuptools";
  pname = "ofxhome";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rpyfqr2q9pnin47rjd4qapl8ngk1m9jx36iqckhdhr8s8gla445";
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
