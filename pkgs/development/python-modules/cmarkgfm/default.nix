{ lib, buildPythonPackage, fetchPypi, cffi, pytest }:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tqVJq6Mnq9mG1nSM8hyGN9dBx2hQ5/773vjSi/4TjjI=";
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
