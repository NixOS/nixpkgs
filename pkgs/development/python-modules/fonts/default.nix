{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "fonts";
  version = "0.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xiZlW3WmBxXhGOROJwZW/SL9j1QlKQH/br8TCK0BxAU=";
  };

  # TODO FIXME
  doCheck = false;

  meta = {
    description = "A Python framework for distributing and managing fonts.";
    homepage = "https://github.com/pimoroni/fonts-python";
  };
}
