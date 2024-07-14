{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "args";
  version = "0.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p4W42DdiXpthw5EIUy2VuFJ0rNZ5aTtx67UVaEj8+BQ=";
  };

  meta = with lib; {
    description = "Command Arguments for Humans";
    homepage = "https://github.com/kennethreitz/args";
  };
}
