{ stdenv
, buildPythonPackage
, fetchPypi
, python
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "ofxtools";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83e1ca0a61463fca99d096a694466726a49979a5d2b8a36a65514c7a8617d3ea";
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
