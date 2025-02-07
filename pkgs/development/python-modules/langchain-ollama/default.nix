{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  langchain-core,
  ollama,

  # testing
  langchain-tests,
  pytestCheckHook,
  pytest-asyncio,
  syrupy,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langchain-ollama";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-ollama==${version}";
    hash = "sha256-Ex8GndMHPHwSSMKu1JxnfGpRj55fh3TR19b3E+KrLUs=";
  };

  sourceRoot = "${src.name}/libs/partners/ollama";

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    ollama
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
    pytest-asyncio
    syrupy
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_ollama" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-ollama==(.*)"
    ];
  };
  # updates the wrong fetcher rev attribute
  passthru.skipBulkUpdate = true;

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-ollama==${version}";
    description = "Integration package connecting Ollama and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
