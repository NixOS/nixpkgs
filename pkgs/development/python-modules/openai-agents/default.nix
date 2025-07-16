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
  version = "0.0.13";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "openai_agents";
    hash = "sha256-a4AxXnXAa1MCxfKtui+eo4RflGFdrtRwa/uHF0D1YaU=";
  };

  # OpenAI 1.76.0 seems to not build currently
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "openai>=1.76.0" "openai"
  '';

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
