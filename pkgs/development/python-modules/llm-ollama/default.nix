{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  llm,

  # dependencies
  click,
  ollama,
  pydantic,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-ollama";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "taketwo";
    repo = "llm-ollama";
    tag = version;
    hash = "sha256-NAJ0tfGRQOxYVAi2X0AI2d9+wyUS3ro1bfMSViZjaR0=";
  };

  build-system = [
    setuptools
    # Follows the reasoning from https://github.com/NixOS/nixpkgs/pull/327800#discussion_r1681586659 about including llm in build-system
    llm
  ];

  dependencies = [
    click
    ollama
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "llm_ollama"
  ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM plugin providing access to Ollama models using HTTP API";
    homepage = "https://github.com/taketwo/llm-ollama";
    changelog = "https://github.com/taketwo/llm-ollama/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
  };
}
