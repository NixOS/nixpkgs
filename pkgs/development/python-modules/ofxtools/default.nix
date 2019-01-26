{ stdenv
, buildPythonPackage
, fetchPypi
, python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16a6bdacadf1fcb3265fcfbe7e36002730fc8613b9490839fc0fa2e9e97a1ed7";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s ofxtools
  '';

  buildInputs = [ sqlalchemy ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/csingley/ofxtools";
    description = "Library for working with Open Financial Exchange (OFX) formatted data used by financial institutions";
    license = licenses.mit;
    broken = true;
  };

}
