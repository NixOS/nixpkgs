{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  anthropic,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "llm-claude-3";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-claude-3";
    tag = version;
    hash = "sha256-3WQufuWlntywgVQUJeQoA3xXtCOIgbG+t4vnKRU0xPA=";
  };

  build-system = [
    setuptools
    llm
  ];
  dependencies = [ anthropic ];

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-recording
  ];

  pythonImportsCheck = [ "llm_claude_3" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LLM plugin for interacting with the Claude 3 family of models";
    homepage = "https://github.com/simonw/llm-claude-3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
  };
}
