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
  version = "2.1.0";

  format = "wheel";

  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-8pDI4LdLFbW1tDLbbdeRWtyPSf6D7+8P0vLqU7XDNVU=";

    # No source is distributed on PyPI
    dist = "py3";
    python = "py3";
    platform = "any";
    abi = "none";
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
