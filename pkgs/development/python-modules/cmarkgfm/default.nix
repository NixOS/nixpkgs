{ lib, buildPythonPackage, fetchPypi, cffi, pytest }:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7a5131a78836e55dcdb1f2c5f17bbaa40e5f83c86a205de1b71a298928e1391f";
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
