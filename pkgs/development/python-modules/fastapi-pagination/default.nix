{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  fastapi,
  pydantic,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-pagination";
  version = "0.15.12";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uriyyo";
    repo = "fastapi-pagination";
    tag = finalAttrs.version;
    hash = "sha256-AzpNyTzlzPHkrx8BghZFHer3w+GpNIUYRo15rRRO0UY=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    fastapi
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "fastapi_pagination" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "FastAPI pagination";
    homepage = "https://github.com/uriyyo/fastapi-pagination";
    changelog = "https://github.com/uriyyo/fastapi-pagination/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
