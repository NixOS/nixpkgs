{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  dataclasses-json,
  langchain-core,
  langchain,
  langsmith,
  pydantic-settings,
  pyyaml,
  requests,
  sqlalchemy,
  tenacity,

  # optional-dependencies
  typer,
  numpy,

  # tests
  httpx,
  langchain-standard-tests,
  lark,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,
}:

buildPythonPackage rec {
  pname = "langchain-community";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-core==${version}";
    hash = "sha256-ACR+JzKcnYXROGOQe6DlZeqcYd40KlesgXSUOybOT20=";
  };

  sourceRoot = "${src.name}/libs/community";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "numpy"
    "pydantic-settings"
    "tenacity"
  ];

  dependencies = [
    aiohttp
    dataclasses-json
    langchain-core
    langchain
    langsmith
    pydantic-settings
    pyyaml
    requests
    sqlalchemy
    tenacity
  ];

  optional-dependencies = {
    cli = [ typer ];
    numpy = [ numpy ];
  };

  pythonImportsCheck = [ "langchain_community" ];

  nativeCheckInputs = [
    httpx
    langchain-standard-tests
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
    inherit (langchain-core) updateScript;
  };

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # Test require network access
    "test_ovhcloud_embed_documents"
    "test_yandex"
    # duckdb-engine needs python-wasmer which is not yet available in Python 3.12
    # See https://github.com/NixOS/nixpkgs/pull/326337 and https://github.com/wasmerio/wasmer-python/issues/778
    "test_table_info"
    "test_sql_database_run"
    # pydantic.errors.PydanticUserError: `SQLDatabaseToolkit` is not fully defined; you should define `BaseCache`, then call `SQLDatabaseToolkit.model_rebuild()`.
    "test_create_sql_agent"
    # pydantic.errors.PydanticUserError: `NatBotChain` is not fully defined; you should define `BaseCache`, then call `NatBotChain.model_rebuild()`.
    "test_proper_inputs"
    # pydantic.errors.PydanticUserError: `NatBotChain` is not fully defined; you should define `BaseCache`, then call `NatBotChain.model_rebuild()`.
    "test_variable_key_naming"
  ];

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-community==${version}";
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/community";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
