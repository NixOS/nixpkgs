{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  anyio,
  asyncer,
  backoff,
  cachetools,
  cloudpickle,
  datasets,
  diskcache,
  joblib,
  json-repair,
  litellm,
  magicattr,
  numpy,
  openai,
  optuna,
  pandas,
  pydantic,
  regex,
  requests,
  rich,
  tenacity,
  tqdm,
  ujson,
  anthropic,
  boto3,
  build,
  datamodel-code-generator,
  mcp,
  pillow,
  pre-commit,
  pytest,
  pytest-asyncio,
  pytest-mock,
  ruff,
  weaviate-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dspy";
  version = "2.6.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = "dspy";
    tag = version;
    hash = "sha256-fwwAjxwwaXiv2ycJGLOW4tgm8WhhIcezVsuIfBzB/g0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    anyio
    asyncer
    backoff
    cachetools
    cloudpickle
    datasets
    diskcache
    joblib
    json-repair
    litellm
    magicattr
    numpy
    openai
    optuna
    pandas
    pydantic
    regex
    requests
    rich
    tenacity
    tqdm
    ujson
  ];

  optional-dependencies = {
    anthropic = [
      anthropic
    ];
    aws = [
      boto3
    ];
    dev = [
      build
      datamodel-code-generator
      litellm
      mcp
      pillow
      pre-commit
      pytest
      pytest-asyncio
      pytest-mock
      ruff
    ] ++ litellm.optional-dependencies.proxy;
    mcp = [
      mcp
    ];
    weaviate = [
      weaviate-client
    ];
  };

  __darwinAllowLocalNetworking = true; # tests run local server

  nativeCheckInputs = [
    pytestCheckHook
    datamodel-code-generator
    litellm
    pillow
  ] ++ litellm.optional-dependencies.proxy;

  # Don't try to write to default cache dir (~/.dspy_cache) during import check
  env.DSPY_CACHEDIR = "$(TMPDIR)/dummy";

  pythonImportsCheck = [
    "dspy"
  ];

  disabledTests = [
    # Require internet access
    "test_pdf_url_support"
    "test_different_mime_types"
    "test_mime_type_from_response_headers"
    "test_pdf_from_file"
    "test_image_input_formats"
    "test_predictor_save_load"
  ];

  meta = {
    description = "DSPy: The framework for programming—not prompting—language models";
    homepage = "https://github.com/stanfordnlp/dspy";
    changelog = "https://github.com/stanfordnlp/dspy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
