{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  chromadb,
  langchain-core,
  langchain-tests,
  numpy,
  pdm-backend,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "langchain-chroma";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-chroma==${version}";
    hash = "sha256-GFDaUA0E25YDHYLwrpsAuOiBWFvHByl61XhwK5NmJbg=";
  };

  sourceRoot = "${src.name}/libs/partners/chroma";

  patches = [ ./001-async-test.patch ];

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [ "numpy" ];

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

  passthru = {
    inherit (langchain-core) updateScript;
    # updates the wrong fetcher rev attribute
    skipBulkUpdate = true;
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
