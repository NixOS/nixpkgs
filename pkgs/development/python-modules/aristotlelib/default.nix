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
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yMNdGfJAbRxJy7VOSzuRwRo7s22AGo1a46WNsj2af/w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    httpx
    textual
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
