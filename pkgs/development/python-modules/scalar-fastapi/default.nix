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
  version = "1.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "scalar_fastapi";
    inherit version;
    hash = "sha256-mXeUxDobSdZmxWWiuF2C+oY5Zvh6LljdZQc9/YwdqGI=";
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
