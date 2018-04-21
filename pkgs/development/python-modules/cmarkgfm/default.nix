{ lib, buildPythonPackage, fetchPypi, cffi, pytest }:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "977d7061779c7ebc5cbe7af71adb795ced96058552fe5f6b646d95b5055959be";
  };

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = https://github.com/jonparrott/cmarkgfm;
    license = licenses.mit;
  };
}
