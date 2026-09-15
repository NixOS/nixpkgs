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
  version = "0.16.0b1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uriyyo";
    repo = "fastapi-pagination";
    tag = finalAttrs.version;
    hash = "sha256-aw199yOFp8kCDaVQmxWdHEUS4sS4QXT9J3w5FRMkFQM=";
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
