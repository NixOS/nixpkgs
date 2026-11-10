{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  version = "0.5.0";
  format = "setuptools";
  pname = "poyo";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-4mlWqngMRfARypiG8ERZDi2P2LYdt7HBz04IafSO1N0=";
  };

  meta = {
    homepage = "https://github.com/hackebrot/poyo";
    description = "Lightweight YAML Parser for Python";
    license = lib.licenses.mit;
  };
})
