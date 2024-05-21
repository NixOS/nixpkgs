{
  lib,
  aiohttp,
  async-timeout,
  azure-core,
  azure-cosmos,
  azure-identity,
  bash,
  buildPythonPackage,
  chardet,
  clarifai,
  cohere,
  dataclasses-json,
  esprima,
  fetchFromGitHub,
  freezegun,
  huggingface-hub,
  jsonpatch,
  langchain-community,
  langchain-core,
  langchain-text-splitters,
  langsmith,
  lark,
  manifest-ml,
  nlpcloud,
  numpy,
  openai,
  pandas,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  qdrant-client,
  requests-mock,
  requests,
  responses,
  sentence-transformers,
  sqlalchemy,
  syrupy,
  tenacity,
  tiktoken,
  toml,
  torch,
  transformers,
  typer,
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.1.52";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-H8rtysRIwyuJEUFI93vid3MsqReyRCER88xztsuYpOc=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  build-system = [ poetry-core ];

  buildInputs = [ bash ];

  dependencies = [
    aiohttp
    dataclasses-json
    jsonpatch
    langchain-community
    langchain-core
    langchain-text-splitters
    langsmith
    numpy
    pydantic
    pyyaml
    requests
    sqlalchemy
    tenacity
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  passthru.optional-dependencies = {
    llms = [
      clarifai
      cohere
      openai
      # openlm
      nlpcloud
      huggingface-hub
      manifest-ml
      torch
      transformers
    ];
    qdrant = [ qdrant-client ];
    openai = [
      openai
      tiktoken
    ];
    text_helpers = [ chardet ];
    clarifai = [ clarifai ];
    cohere = [ cohere ];
    docarray = [
      # docarray
    ];
    embeddings = [ sentence-transformers ];
    javascript = [ esprima ];
    azure = [
      azure-identity
      azure-cosmos
      openai
      azure-core
      # azure-ai-formrecognizer
      # azure-ai-vision
      # azure-cognitiveservices-speech
      # azure-search-documents
      # azure-ai-textanalytics
    ];
    all = [ ];
    cli = [ typer ];
  };

  nativeCheckInputs = [
    freezegun
    lark
    pandas
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  pytestFlagsArray = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
    "--only-core"
  ];

  disabledTests = [
    # These tests have database access
    "test_table_info"
    "test_sql_database_run"
    # These tests have network access
    "test_socket_disabled"
    "test_openai_agent_with_streaming"
    "test_openai_agent_tools_agent"
    # This test may require a specific version of langchain-community
    "test_compatible_vectorstore_documentation"
    # AssertionErrors
    "test_callback_handlers"
    "test_generic_fake_chat_model"
    # Test is outdated
    "test_serializable_mapping"
    "test_person"
    "test_aliases_hidden"
  ];

  pythonImportsCheck = [ "langchain" ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "langchain-server";
  };
}
