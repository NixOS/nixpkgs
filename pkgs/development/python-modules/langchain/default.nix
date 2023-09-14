{ lib
, bash
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, poetry-core
, aiohttp
, async-timeout
, dataclasses-json
, langsmith
, numexpr
, numpy
, openapi-schema-pydantic
, pydantic
, pyyaml
, requests
, sqlalchemy
, tenacity
  # optional dependencies
, anthropic
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
, markdownify
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
, pyowm
, pypdf
, pytesseract
, python-arango
, qdrant-client
, rdflib
, redis
, requests-toolbelt
, sentence-transformers
, spacy
, steamship
, tiktoken
, torch
, transformers
, weaviate-client
, wikipedia
  # test dependencies
, freezegun
, pandas
, pexpect
, pytest-asyncio
, pytest-mock
, pytest-socket
, pytest-vcr
, pytestCheckHook
, responses
, syrupy
, toml
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.0.285";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hwchase17";
    repo = "langchain";
    rev = "refs/tags/v${version}";
    hash = "sha256-3vOfwn8qvPd9dPRnsX14bVSLQQKHLPS5r15S8yAQFpw=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  postPatch = ''
    substituteInPlace langchain/utilities/bash.py \
      --replace '"env", ["-i", "bash", ' '"${lib.getExe bash}", ['
    substituteInPlace tests/unit_tests/test_bash.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

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
    openapi-schema-pydantic
    dataclasses-json
    tenacity
    aiohttp
    numexpr
    langsmith
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  passthru.optional-dependencies = {
    llms = [
      anthropic
      clarifai
      cohere
      openai
      # openllm
      # openlm
      nlpcloud
      huggingface-hub
      manifest-ml
      torch
      transformers
      # xinference
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
      anthropic
      clarifai
      cohere
      openai
      nlpcloud
      huggingface-hub
      # jina
      manifest-ml
      elasticsearch
      opensearch-py
      google-search-results
      faiss
      sentence-transformers
      transformers
      spacy
      nltk
      wikipedia
      beautifulsoup4
      tiktoken
      torch
      jinja2
      pinecone-client
      # pinecone-text
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
      steamship
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
      # esprima
      # octoai-sdk
      rdflib
      # amadeus
      # xinference
      librosa
      python-arango
    ];
  };

  nativeCheckInputs = [
    freezegun
    markdownify
    pandas
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytest-vcr
    pytestCheckHook
    responses
    syrupy
    toml
  ] ++ passthru.optional-dependencies.all;

  pytestFlagsArray = [
    # integration_tests have many network, db access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
  ];

  disabledTests = [
    # these tests have db access
    "test_table_info"
    "test_sql_database_run"

    # these tests have network access
    "test_socket_disabled"
  ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/hwchase17/langchain";
    changelog = "https://github.com/hwchase17/langchain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
