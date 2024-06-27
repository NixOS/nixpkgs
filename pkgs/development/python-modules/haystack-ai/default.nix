{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,

  # Feature flags
  withJax ? false,
  withTorch ? true,
  withTensorflow ? false,

  # Dependencies
  hatchling,
  boilerpy3,
  events,
  flax,
  httpx,
  jsonschema,
  lazy-imports,
  more-itertools,
  networkx,
  pandas,
  pillow,
  platformdirs,
  posthog,
  prompthub-py,
  pydantic,
  quantulum3,
  rank-bm25,
  requests,
  requests-cache,
  scikit-learn,
  sseclient-py,
  tenacity,
  tiktoken,
  tqdm,
  transformers,
  openai-whisper,
  boto3,
  botocore,
  # , beir
  selenium,
  coverage,
  dulwich,
  # , jupytercontrib
  mkdocs,
  mypy,
  pre-commit,
  psutil,
  # , pydoc-markdown
  pylint,
  pytest,
  pytest-asyncio,
  pytest-cov,
  # , pytest-custom-exit-code
  python-multipart,
  reno,
  responses,
  tensorflow,
  toml,
  torch,
  tox,
  watchdog,
  elastic-transport,
  elasticsearch,
  # , azure-ai-formrecognizer
  beautifulsoup4,
  markdown,
  python-docx,
  python-frontmatter,
  python-magic,
  tika,
  black,
  huggingface-hub,
  sentence-transformers,
  mlflow,
  rapidfuzz,
  scipy,
  seqeval,
  pdf2image,
  pytesseract,
  faiss,
  # , faiss-gpu
  pinecone-client,
  onnxruntime,
  onnxruntime-tools,
  # , onnxruntime-gpu
  opensearch-py,
  pymupdf,
  langdetect,
  nltk,
  canals,
  jinja2,
  openai,
  aiorwlock,
  ray,
  psycopg2,
  sqlalchemy,
  sqlalchemy-utils,
  weaviate-client,
}:

# only allow one type of ml backend
assert !(withTorch && (withJax || withTensorflow) || (withJax && withTensorflow));

buildPythonPackage rec {
  pname = "haystack-ai";
  version = "2.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = builtins.replaceStrings [ "-" ] [ "_" ] pname;
    hash = "sha256-u1V96abjLI0q2g/mh3ujE+Mw8DDRXaDfvUv3boC4/LQ=";
  };

  nativeBuildInputs = [
    hatchling
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    # We call it faiss, not faiss-cpu.
    "faiss-cpu"
  ];

  propagatedBuildInputs =
    [
      boilerpy3
      events
      httpx
      jsonschema
      jinja2
      lazy-imports
      more-itertools
      networkx
      openai
      pandas
      pillow
      platformdirs
      posthog
      prompthub-py
      pydantic
      quantulum3
      rank-bm25
      requests
      requests-cache
      scikit-learn
      sseclient-py
      tenacity
      tiktoken
      tqdm
      transformers
    ]
    ++ lib.optionals withJax [ flax ]
    ++ lib.optionals withTensorflow [ tensorflow ]
    ++ lib.optionals withTorch [ torch ];

  env.HOME = "$(mktemp -d)";

  passthru.optional-dependencies = {
    # all = [
    #   farm-haystack
    # ];
    # all-gpu = [
    #   farm-haystack
    # ];
    audio = [ openai-whisper ];
    aws = [
      boto3
      botocore
    ];
    # beir = [
    #   beir
    # ];
    colab = [ pillow ];
    crawler = [ selenium ];
    dev = [
      coverage
      dulwich
      # jupytercontrib
      mkdocs
      mypy
      pre-commit
      psutil
      # pydoc-markdown
      pylint
      pytest
      pytest-asyncio
      pytest-cov
      # pytest-custom-exit-code
      python-multipart
      reno
      responses
      toml
      tox
      watchdog
    ];
    elasticsearch7 = [
      elastic-transport
      elasticsearch
    ];
    elasticsearch8 = [
      elastic-transport
      elasticsearch
    ];
    file-conversion = [
      # azure-ai-formrecognizer
      beautifulsoup4
      markdown
      python-docx
      python-frontmatter
      python-magic
      # python-magic-bin
      tika
    ];
    formatting = [ black ];
    inference = [
      huggingface-hub
      sentence-transformers
      transformers
    ];
    metrics = [
      mlflow
      rapidfuzz
      scipy
      seqeval
    ];
    ocr = [
      pdf2image
      pytesseract
    ];
    only-faiss = [ faiss ];
    # only-faiss-gpu = [
    #   faiss-gpu
    # ];
    only-pinecone = [ pinecone-client ];
    onnx = [
      onnxruntime
      onnxruntime-tools
    ];
    # onnx-gpu = [
    #   onnxruntime-gpu
    #   onnxruntime-tools
    # ];
    opensearch = [ opensearch-py ];
    pdf = [ pymupdf ];
    preprocessing = [
      langdetect
      nltk
    ];
    preview = [
      canals
      jinja2
      lazy-imports
      openai
      pandas
      rank-bm25
      requests
      tenacity
      tqdm
    ];
    ray = [
      aiorwlock
      ray
    ];
    sql = [
      psycopg2
      sqlalchemy
      sqlalchemy-utils
    ];
    weaviate = [ weaviate-client ];
  };

  # the setup for test is intensive, hopefully can be done at some point
  doCheck = false;

  pythonImportsCheck = [ "haystack" ];

  meta = with lib; {
    description = "LLM orchestration framework to build customizable, production-ready LLM applications";
    longDescription = ''
      LLM orchestration framework to build customizable, production-ready LLM applications. Connect components (models, vector DBs, file converters) to pipelines or agents that can interact with your data. With advanced retrieval methods, it's best suited for building RAG, question answering, semantic search or conversational agent chatbots
    '';
    changelog = "https://github.com/deepset-ai/haystack/releases/tag/v${version}";
    homepage = "https://github.com/deepset-ai/haystack";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    # https://github.com/deepset-ai/haystack/issues/5304
    broken = versionAtLeast pydantic.version "2";
  };
}
