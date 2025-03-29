{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

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
}:

buildPythonPackage rec {
  pname = "langchain-community";
  version = "0.3.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-community==${version}";
    hash = "sha256-U7L60GyxRQL9ze22Wy7g6ZdI/IFyAtUe1bRCconv6pg=";
  };

  sourceRoot = "${src.name}/libs/community";

  build-system = [ pdm-backend ];

  patches = [
    # Remove dependency on blockbuster (not available in nixpkgs due to dependency on forbiddenfruit)
    ./rm-blockbuster.patch
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest langchain and -core.
    # That prevents us from updating individul components.
    "langchain"
    "langchain-core"
    "numpy"
    "pydantic-settings"
    "tenacity"
  ];

  pythonRemoveDeps = [
    "blockbuster"
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

  pytestFlagsArray = [ "tests/unit_tests" ];

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
    # Fails due to the lack of blockbuster
    "test_group_dependencies"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^langchain-community==(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-community==${version}";
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/community";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
