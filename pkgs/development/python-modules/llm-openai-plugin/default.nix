{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-openai-plugin,
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
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openai-plugin";
    tag = version;
    hash = "sha256-xlJS+xAKOo40hZH751yrvIuXZw1HQsB7K2anFoMxthU=";
  };

  build-system = [ setuptools ];

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

  passthru.tests = llm.mkPluginTest llm-openai-plugin;

  meta = {
    description = "OpenAI plugin for LLM";
    homepage = "https://github.com/simonw/llm-openai-plugin";
    changelog = "https://github.com/simonw/llm-openai-plugin/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
