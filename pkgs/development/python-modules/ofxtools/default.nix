{ stdenv
, buildPythonPackage
, fetchPypi
, python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.8.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87245679911c0c12429a476fd269611512d3e4b44cb8871159bb76ba70f8a46f";
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
