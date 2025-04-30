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
  diskcache,
  joblib,
  json-repair,
  litellm,
  magicattr,
  numpy,
  openai,
  optuna,
  pydantic,
  regex,
  requests,
  rich,
  tenacity,
  tqdm,
  ujson,
  anthropic,
  build,
  datamodel-code-generator,
  pillow,
  pre-commit,
  pytest,
  pytest-asyncio,
  pytest-mock,
  ruff,
  langchain-core,
  mcp,
  datasets,
  pandas,
  weaviate-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dspy";
  version = "3.0.0b2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = "dspy";
    tag = version;
    hash = "sha256-iMEppyMf4yLLhoKr7AITs1GoSvZ3msjn3IH/Urws4Ds=";
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
    diskcache
    joblib
    json-repair
    litellm
    magicattr
    numpy
    openai
    optuna
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
    dev = [
      build
      datamodel-code-generator
      litellm
      pillow
      pre-commit
      pytest
      pytest-asyncio
      pytest-mock
      ruff
    ];
    langchain = [
      langchain-core
    ];
    mcp = [
      mcp
    ];
    test_extras = [
      datasets
      langchain-core
      mcp
      optuna
      pandas
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
    description = "Framework for programming—not prompting—language models";
    homepage = "https://github.com/stanfordnlp/dspy";
    changelog = "https://github.com/stanfordnlp/dspy/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcwitt ];
  };
}
