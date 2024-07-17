{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  anthropic,
  llm,
  pytestCheckHook,
  pytest,
  pytest-recording,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "llm-claude-3";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-claude-3";
    rev = "refs/tags/${version}";
    hash = "sha256-5qF5BK319PNzB4XsLdYvtyq/SxBDdHJ9IoKWEnvNRp4=";
  };

  build-system = [ setuptools ];
  buildInputs = [ llm ];
  dependencies = [ anthropic ];
  optional-dependencies = {
    test = [
      pytest
      pytest-recording
    ];
  };

  # Test suite requires network access to talk to Claude (duh).
  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = false;
  pythonImportsCheck = [ "llm_claude_3" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LLM plugin for interacting with the Claude 3 family of models";
    homepage = "https://github.com/simonw/llm-claude-3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}

