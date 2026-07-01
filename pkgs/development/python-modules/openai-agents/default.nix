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
  types-requests,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai-agents";
  version = "0.17.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "openai_agents";
    hash = "sha256-ynbn+ILJ2PBuPfuAZMwzvLWl80opgWy5r4Y/OVlk/ww=";
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
    types-requests
    typing-extensions
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
