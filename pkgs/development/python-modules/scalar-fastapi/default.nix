{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # python dependencies
  fastapi,
  pydantic,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "scalar-fastapi";
  version = "1.8.1";
  pyproject = true;

  src = fetchPypi {
    pname = "scalar_fastapi";
    inherit version;
    hash = "sha256-6ttiXThvqUp55UY68Kprz14CvE1mVFTtB5WWCYcVJTE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastapi
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [
    "scalar_fastapi"
  ];

  # Source distribution does not include tests.
  doCheck = false;

  meta = {
    description = "Plugin for FastAPI to render a reference for your OpenAPI document";
    homepage = "https://github.com/scalar/scalar/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
