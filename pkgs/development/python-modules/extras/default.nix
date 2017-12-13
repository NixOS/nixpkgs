{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "extras";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0khvm08rcwm62wc47j8niyl6h13f8w51c8669ifivjdr23g3cbhk";
  };

  # error: error in setup.cfg: command 'test' has no such option 'buffer'
  doCheck = false;

  meta = with lib;{
    description = "A module provides basic functions for parsing mime-type names and matching them against a list of media-ranges";
    homepage = https://code.google.com/p/mimeparse/;
    license = licenses.mit;
  };
}
