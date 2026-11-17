{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  griffelib,
  mcp,
  openai,
  pydantic,
  requests,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai-agents";
  version = "0.25.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "openai_agents";
    hash = "sha256-FcMD5q/uYEbxAjDEtLw/pdN0ROwDchSRFuGfQI2psiE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    griffelib
    mcp
    openai
    pydantic
    requests
    typing-extensions
    websockets
  ];

  pythonImportsCheck = [
    "agents"
  ];

  meta = {
    changelog = "https://github.com/openai/openai-agents-python/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/openai/openai-agents-python";
    description = "Lightweight, powerful framework for multi-agent workflows";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bryanhonof ];
  };
})
