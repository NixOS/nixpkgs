{ lib, buildPythonPackage, fetchPypi, cffi, pytest }:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6a549aba327abd986d6748cf21c8637d741c76850e7fefbdef8d28bfe138e32";
  };

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = "https://github.com/jonparrott/cmarkgfm";
    license = licenses.mit;
  };
}
