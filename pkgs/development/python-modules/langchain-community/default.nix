{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  aiohttp,
  dataclasses-json,
  httpx-sse,
  langchain,
  langchain-core,
  langsmith,
  numpy,
  pydantic-settings,
  pyyaml,
  requests,
  sqlalchemy,
  tenacity,

  # tests
  blockbuster,
  duckdb,
  duckdb-engine,
  httpx,
  langchain-tests,
  lark,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-community";
  version = "0.3.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-community";
    tag = "libs/community/v${version}";
    hash = "sha256-rGU8AYe7993+zMAtHLkNiK+wA+UtZnGkUQsOPMtUQ8w=";
  };

  sourceRoot = "${src.name}/libs/community";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest langchain and -core.
    # That prevents us from updating individual components.
    "langchain"
    "langchain-core"
    "numpy"
    "pydantic-settings"
    "tenacity"
  ];

  pythonRemoveDeps = [
    "bs4"
  ];

  dependencies = [
    aiohttp
    dataclasses-json
    httpx-sse
    langchain
    langchain-core
    langsmith
    numpy
    pydantic-settings
    pyyaml
    requests
    sqlalchemy
    tenacity
  ];

  pythonImportsCheck = [ "langchain_community" ];

  nativeCheckInputs = [
    blockbuster
    duckdb
    duckdb-engine
    httpx
    langchain-tests
    lark
    pandas
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  enabledTestPaths = [
    "tests/unit_tests"
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # requires bs4, aka BeautifulSoup
    "test_importable_all"
    # flaky
    "test_llm_caching"
    "test_llm_caching_async"
  ];

  disabledTestPaths = [
    # depends on Pydantic v1 notations, will not load
    "tests/unit_tests/document_loaders/test_gitbook.py"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "libs/community/v";
  };

  meta = {
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain-community";
    changelog = "https://github.com/langchain-ai/langchain-community/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
