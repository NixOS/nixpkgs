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

buildPythonPackage rec {
  pname = "openai-agents";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "openai_agents";
    hash = "sha256-B7fXWbkphGBhaeuqLCTlVfHJPduJfXLyND8s6feEc+Y=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    griffe
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
    changelog = "https://github.com/openai/openai-agents-python/releases/tag/${version}";
    homepage = "https://github.com/openai/openai-agents-python";
    description = "Lightweight, powerful framework for multi-agent workflows";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bryanhonof ];
  };
}
