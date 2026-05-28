{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  griffe,
  mcp,
  openai,
  pydantic,
  requests,
  types-requests,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "openai-agents";
  version = "0.17.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "openai_agents";
    hash = "sha256-avmv1LQN4jSTyasoXCjNTo/QiCQK9uluLe5FgmrVaP0=";
  };

  build-system = [ hatchling  ];

  dependencies = [
    griffe
    mcp
    openai
    pydantic
    requests
    types-requests
    typing-extensions
  ];

  pythonImportsCheck = [ "agents" ];

  meta = {
    description = "Lightweight, powerful framework for multi-agent workflows";
    homepage = "https://github.com/openai/openai-agents-python";
    changelog = "https://github.com/openai/openai-agents-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryanhonof ];
  };
})
