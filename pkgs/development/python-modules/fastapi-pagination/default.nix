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
  version = "0.16.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uriyyo";
    repo = "fastapi-pagination";
    tag = finalAttrs.version;
    hash = "sha256-xW9zzW7FY/jQSh1XDv8mdYyO5Tts2MTC9Dl1ag/jNwY=";
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
