{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  aiohttp,
  dataclasses-json,
  duckdb-engine,
  langchain,
  langchain-core,
  langsmith,
  lark,
  numpy,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pyyaml,
  requests,
  requests-mock,
  responses,
  sqlalchemy,
  syrupy,
  tenacity,
  toml,
  typer,
}:

buildPythonPackage rec {
  pname = "langchain-community";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/${pname}==${version}";
    hash = "sha256-SVqhNfRAQoVyUsPw55ByPtVzU/h1II/ox8I79QJsci8=";
  };

  sourceRoot = "${src.name}/libs/community";

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    dataclasses-json
    langchain-core
    langchain
    langsmith
    numpy
    pyyaml
    requests
    sqlalchemy
    tenacity
  ];

  passthru.optional-dependencies = {
    cli = [ typer ];
  };

  pythonImportsCheck = [ "langchain_community" ];

  nativeCheckInputs = [
    duckdb-engine
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

  pytestFlagsArray = [ "tests/unit_tests" ];

  passthru = {
    updateScript = langchain-core.updateScript;
  };

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # Test require network access
    "test_ovhcloud_embed_documents"
  ];

  meta = {
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/community";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
