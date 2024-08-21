{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  aiohttp,
  dataclasses-json,
  langchain,
  langchain-core,
  langsmith,
  httpx,
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
  version = "0.2.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain-community==${version}";
    hash = "sha256-HsKWGiWA6uKmRQOMw3efXkjwbBuvDHhf5waNvnvBdG4=";
  };

  sourceRoot = "${src.name}/libs/community";

  preConfigure = ''
    ln -s ${src}/libs/standard-tests/langchain_standard_tests ./langchain_standard_tests

    substituteInPlace pyproject.toml \
      --replace-fail "path = \"../standard-tests\"" "path = \"./langchain_standard_tests\""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    dataclasses-json
    langchain-core
    langchain
    langsmith
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
    # duckdb-engine needs python-wasmer which is not yet available in Python 3.12
    # See https://github.com/NixOS/nixpkgs/pull/326337 and https://github.com/wasmerio/wasmer-python/issues/778
    "test_table_info"
    "test_sql_database_run"
  ];

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-community==${version}";
    description = "Community contributed LangChain integrations";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/community";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
