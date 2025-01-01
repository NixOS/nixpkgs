{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chromadb,
  langchain-core,
  numpy,
  poetry-core,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "langchain-chroma";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-ACR+JzKcnYXROGOQe6DlZeqcYd40KlesgXSUOybOT20=";
  };

  sourceRoot = "${src.name}/libs/partners/chroma";

  patches = [ ./001-async-test.patch ];

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "chromadb" ];

  dependencies = [
    langchain-core
    chromadb
    numpy
  ];

  pythonImportsCheck = [ "langchain_chroma" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Bad integration test, not used or vetted by the langchain team
    "test_chroma_update_document"
  ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-chroma==${version}";
    description = "Integration package connecting Chroma and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/chroma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
