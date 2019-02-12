{ stdenv
, buildPythonPackage
, fetchPypi
, python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "520345d3b440447696b8f84a4e752573666ff8d1fe0300316cd07995ae05176f";
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
