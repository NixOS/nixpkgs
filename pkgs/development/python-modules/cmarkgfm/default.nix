{ lib, buildPythonPackage, fetchPypi, cffi, pytest }:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84465f6534f49687f1a8069d48044799d2dd3f4e7ff06b66b7eea1502f3c402d";
  };

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  # no tests in PyPI tarball
  # see https://github.com/jonparrott/cmarkgfm/pull/6
  doCheck = false;

  meta = with lib; {
    description = "Minimal bindings to GitHub's fork of cmark";
    homepage = https://github.com/jonparrott/cmarkgfm;
    license = licenses.mit;
  };
}
