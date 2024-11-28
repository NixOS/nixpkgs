{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  python-dotenv,
  langchain,
  requests,
  openai,
  chromadb,
  posthog,
  rich,
  beautifulsoup4,
  pypdf,
  gptcache,
  pysbd,
  mem0ai,
  schema,
  langchain-openai,
  sqlalchemy,
  alembic,
  langchain-cohere,
  langchain-community,
  langsmith,

  # runtime dependencies
  google-cloud-aiplatform,
}:

buildPythonPackage rec {
  pname = "embedchain";
  version = mem0ai.version;

  pyproject = true;

  disabled = pythonOlder "3.9";

  src = mem0ai.src;
  sourceRoot = "${src.name}/embedchain";

  dependencies = [
    python-dotenv
    langchain
    requests
    openai
    chromadb
    posthog
    rich
    beautifulsoup4
    pypdf
    google-cloud-aiplatform
    gptcache
    pysbd
    mem0ai
    schema
    langchain-openai
    sqlalchemy
    alembic
    langchain-cohere
    langchain-community
    langsmith
  ];

  pythonRelaxDeps = [
    "chromadb"
    "langchain-community"
  ];

  build-system = [ poetry-core ];

  enableParallelBuilding = true;

  doCheck = true;

  # This is for the import check.
  # Importing embedchain needs a writable EMBEDCHAIN_CONFIG_DIR,
  # and also transitively imports mem0, which needs a writable MEM0_DIR.
  postInstall = ''
    export EMBEDCHAIN_CONFIG_DIR=$(mktemp -d)
    export MEM0_DIR=$(mktemp -d)
  '';

  pythonImportsCheck = [ "embedchain" ];

  # Note: We don't need a passthru.updateScript because this package will updated when mem0ai does

  meta = {
    description = "Embedchain is a RAG framework to create data pipelines. It loads, indexes, retrieves and syncs all the data.";
    downloadPage = mem0ai.meta.downloadPage;
    homepage = "https://github.com/mem0ai/mem0/tree/main/embedchain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexchapman ];
  };
}
