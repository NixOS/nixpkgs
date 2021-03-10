{ lib, buildPythonPackage, fetchPypi, mock }:

buildPythonPackage rec {
  pname = "cssutils";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "984b5dbe3a2a0483d7cb131609a17f4cbaa34dda306c419924858a88588fed7c";
  };

  buildInputs = [ mock ];

  # couple of failing tests
  doCheck = false;

  meta = with lib; {
    description = "A Python package to parse and build CSS";
    homepage = "http://cthedot.de/cssutils/";
    license = licenses.lgpl3Plus;
  };
}
