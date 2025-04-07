{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,
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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-ollama==${version}";
    hash = "sha256-KsQV2jM2rXbFg+ZlDnpw8sD3Nm8C37BWo+DkDTaMDtQ=";
  };

  sourceRoot = "${src.name}/libs/partners/ollama";

  build-system = [
    pdm-backend
    poetry-core
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individul components.
    "langchain-core"
  ];

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

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-ollama==${version}";
    description = "Integration package connecting Ollama and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/ollama";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
