{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # python dependencies
  annotated-types,
  anyio,
  fastapi,
  idna,
  pydantic,
  sniffio,
  starlette,
  typing-extensions,

  # tests
  pytestCheckHook,
  httpx,
}:

buildPythonPackage rec {
  pname = "scalar-fastapi";
  version = "1.6.1";
  pyproject = true;

  src = fetchPypi {
    pname = "scalar_fastapi";
    inherit version;
    hash = "sha256-XTzJbw84TTiLWKuldqkDuQfjyY2sqxM5ByIQ6UbE8DM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    annotated-types
    anyio
    fastapi
    idna
    pydantic
    sniffio
    starlette
    typing-extensions
  ];

  pythonImportsCheck = [
    "scalar_fastapi"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx
  ];

  meta = {
    description = "Plugin for FastAPI to render a reference for your OpenAPI document";
    homepage = "https://github.com/scalar/scalar/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
