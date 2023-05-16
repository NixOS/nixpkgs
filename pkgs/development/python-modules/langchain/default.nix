{ lib
<<<<<<< HEAD
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
=======
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
, protobuf
  # test dependencies
, pytest-vcr
, pytest-asyncio
, pytest-mock
, pandas
, toml
, freezegun
, responses
, pexpect
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "langchain";
<<<<<<< HEAD
  version = "0.0.285";
=======
  version = "0.0.166";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hwchase17";
    repo = "langchain";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-3vOfwn8qvPd9dPRnsX14bVSLQQKHLPS5r15S8yAQFpw=";
  };

  sourceRoot = "${src.name}/libs/langchain";

=======
    hash = "sha256-i6CvboYZigky49a7X8RuQH2EfcucJPtEtFEzZxaNJG8=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace langchain/utilities/bash.py \
      --replace '"env", ["-i", "bash", ' '"${lib.getExe bash}", ['
    substituteInPlace tests/unit_tests/test_bash.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  nativeBuildInputs = [
    poetry-core
<<<<<<< HEAD
    pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    bash
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.optional-dependencies = {
    llms = [
      anthropic
<<<<<<< HEAD
      clarifai
      cohere
      openai
      # openllm
      # openlm
=======
      cohere
      openai
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      nlpcloud
      huggingface-hub
      manifest-ml
      torch
      transformers
<<<<<<< HEAD
      # xinference
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
    qdrant = [
      qdrant-client
    ];
    openai = [
      openai
<<<<<<< HEAD
      tiktoken
    ];
    text_helpers = [
      chardet
    ];
    clarifai = [
      clarifai
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
    cohere = [
      cohere
    ];
<<<<<<< HEAD
    docarray = [
      # docarray
    ];
    embeddings = [
      sentence-transformers
    ];
    javascript = [
      esprima
    ];
=======
    embeddings = [
      sentence-transformers
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    azure = [
      azure-identity
      azure-cosmos
      openai
      azure-core
<<<<<<< HEAD
      # azure-ai-formrecognizer
      # azure-ai-vision
      # azure-cognitiveservices-speech
      # azure-search-documents
    ];
    all = [
      anthropic
      clarifai
=======
    ];
    all = [
      anthropic
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      cohere
      openai
      nlpcloud
      huggingface-hub
      # jina
      manifest-ml
      elasticsearch
      opensearch-py
<<<<<<< HEAD
      google-search-results
=======
      # google-search-results
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      faiss
      sentence-transformers
      transformers
      spacy
      nltk
<<<<<<< HEAD
      wikipedia
=======
      # wikipedia
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      beautifulsoup4
      tiktoken
      torch
      jinja2
      pinecone-client
      # pinecone-text
      weaviate-client
      redis
      google-api-python-client
<<<<<<< HEAD
      google-auth
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      # wolframalpha
      qdrant-client
      # tensorflow-text
      pypdf
      networkx
      # nomic
      # aleph-alpha-client
      # deeplake
<<<<<<< HEAD
      # libdeeplake
      pgvector
      psycopg2
=======
      # pgvector
      psycopg2
      boto3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      pyowm
      pytesseract
      html2text
      atlassian-python-api
<<<<<<< HEAD
      gptcache
=======
      # gptcache
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      duckduckgo-search
      # arxiv
      azure-identity
      # clickhouse-connect
      azure-cosmos
      # lancedb
<<<<<<< HEAD
      # langkit
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      lark
      pexpect
      # pyvespa
      # O365
      jq
      # docarray
<<<<<<< HEAD
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
=======
      protobuf
      # hnswlib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
  };

  nativeCheckInputs = [
<<<<<<< HEAD
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
=======
    pytestCheckHook
    pytest-vcr
    pytest-mock
    pytest-asyncio
    pandas
    toml
    freezegun
    responses
  ];

  pytestFlagsArray = [
    # integration_tests have many network, db access and require `OPENAI_API_KEY`, etc.
    "--ignore=tests/integration_tests"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  disabledTests = [
    # these tests have db access
    "test_table_info"
    "test_sql_database_run"
<<<<<<< HEAD

    # these tests have network access
    "test_socket_disabled"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/hwchase17/langchain";
    changelog = "https://github.com/hwchase17/langchain/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
