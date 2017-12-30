{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "extras";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h7zx4dfyclalg0fqnfjijpn0f793a9mx8sy3b27gd31nr6dhq3s";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = https://code.google.com/p/mimeparse/;
    license = lib.licenses.mit;
  };
}