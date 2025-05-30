{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pox";
  version = "0.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hO7tOWABWaYoBKrPwA41Pt6q5n2MZHzKqrc6bv7T9gU=";
  };

  # Test sare failing the sandbox
  doCheck = false;

  pythonImportsCheck = [ "pox" ];

  meta = with lib; {
    description = "Utilities for filesystem exploration and automated builds";
    mainProgram = "pox";
    homepage = "https://pox.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
