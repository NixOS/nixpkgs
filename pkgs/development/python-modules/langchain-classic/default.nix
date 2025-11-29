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
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,
}:

buildPythonPackage rec {
  pname = "langchain-classic";
  version = "langchain-xai==1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    # no tagged releases avaialble
    rev = "3dfea96ec1d2dac4e506d287860ee943c183c9f1";
    hash = "sha256-U3UllSSa4tFz+nXAP6aNoYceU/xCPbwKSP2F2et+qgQ=";
  };

  sourceRoot = "${src.name}/libs/langchain";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    "langchain-core"
  ];

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
    pytestCheckHook
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

  pythonImportsCheck = [ "langchain_classic" ];

  meta = {
    description = "Classic (0.x) compatibility layer for LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
