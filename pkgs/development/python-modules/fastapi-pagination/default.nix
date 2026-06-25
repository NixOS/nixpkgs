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
  version = "0.15.15";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uriyyo";
    repo = "fastapi-pagination";
    tag = finalAttrs.version;
    hash = "sha256-G6qF57MWlrZ4Poc+M2YtpKqquhOR/Zh4TnFmL2qZ1Uk=";
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
