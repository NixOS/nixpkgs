{ stdenv
, buildPythonPackage
, fetchPypi
, python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88f289a60f4312a1599c38a8fb3216e2b46d10cc34476f9a16a33ac8aac7ec35";
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
