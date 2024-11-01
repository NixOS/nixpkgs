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
  langchain-standard-tests,
  pytestCheckHook,
  pytest-asyncio,
  syrupy,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "langchain-ollama";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-ACR+JzKcnYXROGOQe6DlZeqcYd40KlesgXSUOybOT20=";
  };

  sourceRoot = "${src.name}/libs/partners/ollama";

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    ollama
  ];

  nativeCheckInputs = [
    langchain-standard-tests
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

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-ollama==${version}";
    description = "Integration package connecting Ollama and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
