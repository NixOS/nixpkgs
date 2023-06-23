{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, numpy
, pyyaml
, sqlalchemy
, requests
, async-timeout
, aiohttp
, numexpr
, openapi-schema-pydantic
, dataclasses-json
, tqdm
, tenacity
, bash
  # optional dependencies
, anthropic
, cohere
, openai
, nlpcloud
, huggingface-hub
, manifest-ml
, torch
, transformers
, qdrant-client
, sentence-transformers
, azure-identity
, azure-cosmos
, azure-core
, elasticsearch
, opensearch-py
, google-search-results
, faiss
, spacy
, nltk
, beautifulsoup4
, tiktoken
, jinja2
, pinecone-client
, weaviate-client
, redis
, google-api-python-client
, pypdf
, networkx
, psycopg2
, boto3
, pyowm
, pytesseract
, html2text
, atlassian-python-api
, duckduckgo-search
, lark
, jq
, steamship
, pdfminer-six
, lxml
, chardet
, requests-toolbelt
, neo4j
, langchainplus-sdk
  # test dependencies
, pytest-vcr
, pytest-asyncio
, pytest-mock
, pytest-socket
, pandas
, syrupy
, toml
, freezegun
, responses
, pexpect
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.0.201";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hwchase17";
    repo = "langchain";
    rev = "refs/tags/v${version}";
    hash = "sha256-+mS6rKypDrlKFg+c0GPAZ0YX7UYN+mlilnbX2hptLt0=";
  };

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
    numpy
    pyyaml
    sqlalchemy
    requests
    aiohttp
    numexpr
    openapi-schema-pydantic
    dataclasses-json
    tqdm
    tenacity
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ] ++ passthru.optional-dependencies.all;

  passthru.optional-dependencies = {
    llms = [
      anthropic
      cohere
      openai
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
    ];
    text_helpers = [
      chardet
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
    azure = [
      azure-identity
      azure-cosmos
      openai
      azure-core
    ];
    all = [
      anthropic
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
      # wikipedia
      beautifulsoup4
      tiktoken
      torch
      jinja2
      pinecone-client
      # pinecone-text
      weaviate-client
      redis
      google-api-python-client
      # wolframalpha
      qdrant-client
      # tensorflow-text
      pypdf
      networkx
      # nomic
      # aleph-alpha-client
      # deeplake
      # pgvector
      psycopg2
      boto3
      pyowm
      pytesseract
      html2text
      atlassian-python-api
      # gptcache
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
      langchainplus-sdk
    ];
  };

  pythonRelaxDeps = [
    "langchainplus-sdk"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-vcr
    pytest-mock
    pytest-socket
    pytest-asyncio
    pandas
    syrupy
    toml
    freezegun
    responses
  ];

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
