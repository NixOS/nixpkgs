{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  griffelib,
  httpx2,
  mcp,
  openai,
  pydantic,
  requests,
  types-requests,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai-agents";
  version = "0.18.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "openai_agents";
    hash = "sha256-aJrYjI9kQ1QT3ecHykX7QtVSF/9u9jqrPWOMM/eOBL8=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "openai"
  ];

  dependencies = [
    griffelib
    httpx2
    mcp
    openai
    pydantic
    requests
    types-requests
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
