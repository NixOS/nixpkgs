{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pydantic,
  httpx,
  pathspec,
}:

buildPythonPackage rec {
  pname = "aristotlelib";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RqvjheyW6/5qFB6oANNz7MBV5qEJmP3ZKF+kMK3y9zY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    httpx
    pathspec
  ];

  pythonImportsCheck = [ "aristotlelib" ];

  meta = {
    description = "Python library for automated theorem proving with Lean";
    homepage = "https://aristotle.harmonic.fun";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aristotle";
  };
}
