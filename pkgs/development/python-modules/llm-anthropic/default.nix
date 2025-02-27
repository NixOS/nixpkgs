{
  lib,
  callPackage,
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
  pname = "llm-anthropic";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-tKgcag8sBJA4QWunaFyZxkZH0mtc0SS17104YuX1Kac=";
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

  pythonImportsCheck = [ "llm_anthropic" ];

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
  };
}
