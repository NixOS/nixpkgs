{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  chromadb,
  langchain-core,
  numpy,

  # tests
  langchain-tests,
  pytestCheckHook,
  pytest-asyncio,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-chroma";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-chroma==${version}";
    hash = "sha256-w4xvPPLYkPiQA34bimVHLe+vghMI9Pq36CHoE/EMnr8=";
  };

  sourceRoot = "${src.name}/libs/partners/chroma";

  patches = [ ./001-async-test.patch ];

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "numpy"
  ];

  dependencies = [
    chromadb
    langchain-core
    numpy
  ];

  pythonImportsCheck = [ "langchain_chroma" ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Bad integration test, not used or vetted by the langchain team
    "test_chroma_update_document"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-chroma==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting Chroma and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/chroma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
