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
  version = "0.3.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-108DlyLAmL7CxEkYWol5wybylpvklFeGaGjGBcbRWg4=";
  };

  sourceRoot = "${src.name}/libs/partners/chroma";

  patches = [ ./001-async-test.patch ];

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "chromadb"
    "numpy"
  ];

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
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-chroma==${src.tag}";
    description = "Integration package connecting Chroma and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/chroma";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
