{ lib, buildPythonPackage, fetchPypi, cffi, pytest }:

buildPythonPackage rec {
  pname = "cmarkgfm";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f20900f16377f2109783ae9348d34bc80530808439591c3d3df73d5c7ef1a00c";
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
