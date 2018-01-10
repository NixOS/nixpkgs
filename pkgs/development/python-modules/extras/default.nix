{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "extras";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "132e36de10b9c91d5d4cc620160a476e0468a88f16c9431817a6729611a81b4e";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = https://code.google.com/p/mimeparse/;
    license = lib.licenses.mit;
  };
}