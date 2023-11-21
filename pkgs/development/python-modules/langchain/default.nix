{ lib
, bash
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, poetry-core
, aiohttp
, anyio
, async-timeout
, dataclasses-json
, jsonpatch
, langsmith
, numpy
, pydantic
, pyyaml
, requests
, sqlalchemy
, tenacity
  # optional dependencies
, atlassian-python-api
, azure-core
, azure-cosmos
, azure-identity
, beautifulsoup4
, chardet
, clarifai
, cohere
, duckduckgo-search
, elasticsearch
, esprima
, faiss
, google-api-python-client
, google-auth
, google-search-results
, gptcache
, html2text
, huggingface-hub
, jinja2
, jq
, lark
, librosa
, lxml
, manifest-ml
, neo4j
, networkx
, nlpcloud
, nltk
, openai
, opensearch-py
, pdfminer-six
, pgvector
, pinecone-client
, psycopg2
, pymongo
, pyowm
, pypdf
, pytesseract
, python-arango
, qdrant-client
, rdflib
, redis
, requests-toolbelt
, sentence-transformers
, tiktoken
, torch
, transformers
, typer
, weaviate-client
, wikipedia
  # test dependencies
, freezegun
, pandas
, pexpect
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
  version = "0.0.334";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hwchase17";
    repo = "langchain";
    rev = "refs/tags/v${version}";
    hash = "sha256-mXPqc8wF9DhEtITm8h5R9kHBcMJ7AEK4kL5Z7V2p8NE=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  buildInputs = [
    bash
  ];

  propagatedBuildInputs = [
    pydantic
    sqlalchemy
    requests
    pyyaml
    numpy
    dataclasses-json
    tenacity
    aiohttp
    langsmith
    anyio
    jsonpatch
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
    ];
    all = [
      clarifai
      cohere
      openai
      nlpcloud
      huggingface-hub
      manifest-ml
      elasticsearch
      opensearch-py
      google-search-results
      faiss
      sentence-transformers
      transformers
      nltk
      wikipedia
      beautifulsoup4
      tiktoken
      torch
      jinja2
      pinecone-client
      # pinecone-text
      # marqo
      pymongo
      weaviate-client
      redis
      google-api-python-client
      google-auth
      # wolframalpha
      qdrant-client
      # tensorflow-text
      pypdf
      networkx
      # nomic
      # aleph-alpha-client
      # deeplake
      # libdeeplake
      pgvector
      psycopg2
      pyowm
      pytesseract
      html2text
      atlassian-python-api
      gptcache
      duckduckgo-search
      # arxiv
      azure-identity
      # clickhouse-connect
      azure-cosmos
      # lancedb
      # langkit
      lark
      pexpect
      # pyvespa
      # O365
      jq
      # docarray
      pdfminer-six
      lxml
      requests-toolbelt
      neo4j
      # openlm
      # azure-ai-formrecognizer
      # azure-ai-vision
      # azure-cognitiveservices-speech
      # momento
      # singlestoredb
      # tigrisdb
      # nebula3-python
      # awadb
      esprima
      rdflib
      # amadeus
      librosa
      python-arango
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
  ];

  pythonImportsCheck = [
    "langchain"
  ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/hwchase17/langchain";
    changelog = "https://github.com/hwchase17/langchain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
