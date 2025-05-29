{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  openai,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  syrupy,
  cogapp,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "llm-openai-plugin";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openai-plugin";
    tag = version;
    hash = "sha256-UoUxCwR+qOUufHuS0gw6A5Q7sB77VO4HYuMjFGN7mhA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    llm
    openai
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-recording
    syrupy
    cogapp
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_openai" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "OpenAI plugin for LLM";
    homepage = "https://github.com/simonw/llm-openai-plugin";
    changelog = "https://github.com/simonw/llm-openai-plugin/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
