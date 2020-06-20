{ stdenv, buildPythonPackage, fetchPypi, mock }:

buildPythonPackage rec {
  pname = "cssutils";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a2fcf06467553038e98fea9cfe36af2bf14063eb147a70958cfcaa8f5786acaf";
  };

  buildInputs = [ mock ];

  # couple of failing tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python package to parse and build CSS";
    homepage = "http://cthedot.de/cssutils/";
    license = licenses.lgpl3Plus;
  };
}
