{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BlL28hA/5tS6Y4vrb6jT6KaP1EvLYzFcYUEYUVvMOvs=";
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
