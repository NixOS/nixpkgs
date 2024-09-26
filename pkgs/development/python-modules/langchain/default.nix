{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # buildInputs
  bash,

  # dependencies
  aiohttp,
  langchain-core,
  langchain-text-splitters,
  langsmith,
  pydantic,
  pyyaml,
  requests,
  sqlalchemy,
  tenacity,
  async-timeout,

  # optional-dependencies
  numpy,

  # tests
  freezegun,
  httpx,
  lark,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "refs/tags/langchain==${version}";
    hash = "sha256-2dHsZWn1MN/gLnUdYp84gbtWkvB0j0iieij4W9tzPzY=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  build-system = [ poetry-core ];

  buildInputs = [ bash ];

  dependencies = [
    aiohttp
    langchain-core
    langchain-text-splitters
    langsmith
    pydantic
    pyyaml
    requests
    sqlalchemy
    tenacity
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    freezegun
    httpx
    lark
    pandas
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  pytestFlagsArray = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
    "--only-core"
  ];

  disabledTests = [
    # These tests have database access
    "test_table_info"
    "test_sql_database_run"
    # These tests have network access
    "test_socket_disabled"
    "test_openai_agent_with_streaming"
    "test_openai_agent_tools_agent"
    # This test may require a specific version of langchain-community
    "test_compatible_vectorstore_documentation"
    # AssertionErrors
    "test_callback_handlers"
    "test_generic_fake_chat_model"
    # Test is outdated
    "test_serializable_mapping"
    "test_person"
    "test_aliases_hidden"
  ];

  pythonImportsCheck = [ "langchain" ];

  passthru = {
    updateScript = langchain-core.updateScript;
  };

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "langchain-server";
  };
}
