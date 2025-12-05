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
  langchain-classic,
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
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-community";
    tag = "libs/community/v${version}";
    hash = "sha256-N92YDmej2shQQlktr0veFOKyGFWemFj0hdJIYu1rYSc=";
  };

  sourceRoot = "${src.name}/libs/community";

  build-system = [ pdm-backend ];

  # Only needed for mixed python 3.12/3.13 builds
  pythonRelaxDeps = [
    "numpy"
  ];

  dependencies = [
    aiohttp
    dataclasses-json
    httpx-sse
    langchain-classic
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
