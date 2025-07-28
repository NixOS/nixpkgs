{
  lib,
  nix-update-script,
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
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "openai_agents";
    hash = "sha256-ldStGUxcDPGkADjLcB7ujs2q92mNh7sT48LFz/gMS00=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/openai/openai-agents-python/releases/tag/${version}";
    homepage = "https://github.com/openai/openai-agents-python";
    description = "A lightweight, powerful framework for multi-agent workflows";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bryanhonof ];
  };
}
