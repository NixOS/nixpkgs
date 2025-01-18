{
  lib,
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
}:

buildPythonPackage rec {
  pname = "llm-ollama";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "taketwo";
    repo = "llm-ollama";
    tag = version;
    hash = "sha256-9AgHX2FJRXSKZOLt7JR/9Fg4i2HGNQY2vSsJa4+2BGQ=";
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
  ];

  # These tests try to access the filesystem and fail
  disabledTests = [
    "test_registered_model"
    "test_registered_chat_models"
    "test_registered_embedding_models"
    "test_registered_models_when_ollama_is_down"
  ];

  pythonImportCheck = [
    "llm_ollama"
  ];

  meta = {
    description = "LLM plugin providing access to Ollama models using HTTP API";
    homepage = "https://github.com/taketwo/llm-ollama";
    changelog = "https://github.com/taketwo/llm-ollama/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
  };
}
