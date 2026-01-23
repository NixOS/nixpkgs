{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hO7tOWABWaYoBKrPwA41Pt6q5n2MZHzKqrc6bv7T9gU=";
  };

  # Test sare failing the sandbox
  doCheck = false;

  pythonImportsCheck = [ "pox" ];

  meta = {
    description = "Utilities for filesystem exploration and automated builds";
    mainProgram = "pox";
    homepage = "https://pox.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
