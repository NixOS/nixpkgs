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
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/v${version}";
    hash = "sha256-tBEO0GOY1cqO5FOYnBXAOSupSRhcoI9u4Nu4FieId74=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    bash
  ];

  propagatedBuildInputs = [
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
    # integration_tests have many network, db access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
    "--only-core"
  ];

  disabledTests = [
    # these tests have db access
    "test_table_info"
    "test_sql_database_run"

    # these tests have network access
    "test_socket_disabled"

    # this test may require a specific version of langchain-community
    "test_compatible_vectorstore_documentation"
  ];

  pythonImportsCheck = [
    "langchain"
  ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    mainProgram = "langchain-server";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
