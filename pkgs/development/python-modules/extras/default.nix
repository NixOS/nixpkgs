{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "extras";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ey423hC5yR1dTMYgFgpHbgRoqI8WyUMYF6ZylhGoG04=";
  };

  # error: invalid command 'test'
  doCheck = false;

  meta = {
    description = "Useful extra bits for Python - things that should be in the standard library";
    homepage = "https://github.com/testing-cabal/extras";
    license = lib.licenses.mit;
  };
}
