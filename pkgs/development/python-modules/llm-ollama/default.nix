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
  pytest-asyncio,
  pytest-mock,
  writableTmpDirAsHomeHook,
  llm-ollama,
}:

buildPythonPackage rec {
  pname = "llm-ollama";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "taketwo";
    repo = "llm-ollama";
    tag = version;
    hash = "sha256-xQmUN1PKZofyy+Q4pWHl386gJg499GczDGc1SVsnWCg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    llm
    ollama
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "llm_ollama"
  ];

  passthru.tests = llm.mkPluginTest llm-ollama;

  meta = {
    description = "LLM plugin providing access to Ollama models using HTTP API";
    homepage = "https://github.com/taketwo/llm-ollama";
    changelog = "https://github.com/taketwo/llm-ollama/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erethon ];
  };
}
