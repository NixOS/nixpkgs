{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pydantic,
  httpx,
  textual,
}:

buildPythonPackage rec {
  pname = "aristotlelib";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ZylKx55/gBkADcZn75ythdhULhFn2hoaSrBzZ2lD30=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    httpx
    textual
  ];

  meta = {
    description = "Python library for automated theorem proving with Lean";
    homepage = "https://aristotle.harmonic.fun";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aristotle";
  };
}
