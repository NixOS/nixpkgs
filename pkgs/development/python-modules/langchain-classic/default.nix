{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  langchain-core,
  langchain-text-splitters,
  langsmith,
  pydantic,
  pyyaml,
  requests,
  sqlalchemy,

  # tests
  blockbuster,
  cffi,
  freezegun,
  langchain-openai,
  langchain-tests,
  lark,
  numpy,
  packaging,
  pandas,
  pytest-asyncio,
  pytest-dotenv,
  pytest-mock,
  pytest-socket,
  pytest-xdist,
  pytest8_3CheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,

  # update
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-classic";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-classic==${finalAttrs.version}";
    hash = "sha256-NH2l2Htt5nAzzvwKUgQNwvQBLxZKhOLxnxthvK/Yh4I=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/langchain";

  build-system = [ hatchling ];

  dependencies = [
    langchain-core
    langchain-text-splitters
    langsmith
    pydantic
    pyyaml
    requests
    sqlalchemy
  ];

  nativeCheckInputs = [
    blockbuster
    cffi
    freezegun
    langchain-core
    langchain-openai
    langchain-tests
    langchain-text-splitters
    lark
    numpy
    packaging
    pandas
    pytest-asyncio
    pytest-dotenv
    pytest-mock
    pytest-socket
    pytest-xdist
    pytest8_3CheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  enabledTestPaths = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
  ];

  disabledTests = [
    # Network access (web.example.com)
    "test_socket_disabled"
  ];

  # Bulk updater selects wrong tag
  passthru = {
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-classic==";
    };
  };

  pythonImportsCheck = [ "langchain_classic" ];

  meta = {
    description = "Classic (0.x) compatibility layer for LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
