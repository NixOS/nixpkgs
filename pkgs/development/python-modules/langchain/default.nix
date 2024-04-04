{ lib
, bash
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, aiohttp
, async-timeout
, dataclasses-json
, jsonpatch
, langsmith
, langchain-core
, langchain-community
, langchain-text-splitters
, numpy
, pydantic
, pyyaml
, requests
, sqlalchemy
, tenacity
  # optional dependencies
, azure-core
, azure-cosmos
, azure-identity
, chardet
, clarifai
, cohere
, esprima
, huggingface-hub
, lark
, manifest-ml
, nlpcloud
, openai
, qdrant-client
, sentence-transformers
, tiktoken
, torch
, transformers
, typer
  # test dependencies
, freezegun
, pandas
, pytest-asyncio
, pytest-mock
, pytest-socket
, pytestCheckHook
, requests-mock
, responses
, syrupy
, toml
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.1.14";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/v${version}";
    hash = "sha256-wV6QFeJ/kV0nDVlA2qsJ9p1n3Yxy8Q/NZ1IX8cFtzcg=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  build-system = [
    poetry-core
  ];

  buildInputs = [
    bash
  ];

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
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

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
    qdrant = [
      qdrant-client
    ];
    openai = [
      openai
      tiktoken
    ];
    text_helpers = [
      chardet
    ];
    clarifai = [
      clarifai
    ];
    cohere = [
      cohere
    ];
    docarray = [
      # docarray
    ];
    embeddings = [
      sentence-transformers
    ];
    javascript = [
      esprima
    ];
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
    all = [
    ];
    cli = [
      typer
    ];
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
  ];

  pythonImportsCheck = [
    "langchain"
  ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "langchain-server";
  };
}
