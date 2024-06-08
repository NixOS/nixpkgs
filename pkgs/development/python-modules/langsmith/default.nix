{
  lib,
  stdenv,
  anthropic,
  attr,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  freezegun,
  httpx,
  instructor,
  orjson,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  requests,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "langsmith";
  version = "0.1.64";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-oAAbki0Mo4qmjIFpD4girpRuSKr9eLPU6Da6muG0NNk=";
  };

  sourceRoot = "${src.name}/python";

  pythonRelaxDeps = [ "orjson" ];

  build-system = [
    poetry-core
    pythonRelaxDepsHook
  ];

  dependencies = [
    orjson
    pydantic
    requests
  ];

  nativeCheckInputs = [
    anthropic
    fastapi
    freezegun
    httpx
    instructor
    pytest-asyncio
    pytestCheckHook
    uvicorn
  ] ++ lib.optionals stdenv.isLinux [ attr ];

  disabledTests = [
    # These tests require network access
    "integration_tests"
    # due to circular import
    "test_as_runnable"
    "test_as_runnable_batch"
    "test_as_runnable_async"
    "test_as_runnable_async_batch"
    # Test requires git repo
    "test_git_info"
    # Tests require OpenAI API key
    "test_chat_async_api"
    "test_chat_sync_api"
    "test_completions_async_api"
    "test_completions_sync_api"
  ];

  disabledTestPaths = [
    # due to circular import
    "tests/integration_tests/test_client.py"
    "tests/unit_tests/test_client.py"
    # Tests require a Langsmith API key
    "tests/evaluation/test_evaluation.py"
    "tests/external/test_instructor_evals.py"
  ];

  pythonImportsCheck = [ "langsmith" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Client library to connect to the LangSmith LLM Tracing and Evaluation Platform";
    homepage = "https://github.com/langchain-ai/langsmith-sdk";
    changelog = "https://github.com/langchain-ai/langsmith-sdk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "langsmith";
  };
}
