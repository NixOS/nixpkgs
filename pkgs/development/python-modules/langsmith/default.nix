{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  httpx,
  orjson,
  pydantic,
  requests,
  requests-toolbelt,
  uuid-utils,
  xxhash,
  zstandard,

  # tests
  anthropic,
  attrs,
  dataclasses-json,
  multipart,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-httpx,
  pytest-socket,
  pytest-vcr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "langsmith";
  version = "0.7.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-praKCpNzZ8e+QEU9Ji9ryspzIiF9X98rUOvMbwjMZho=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ hatchling ];

  dependencies = [
    httpx
    orjson
    pydantic
    requests
    requests-toolbelt
    uuid-utils
    xxhash
    zstandard
  ];

  nativeCheckInputs = [
    anthropic
    attrs
    dataclasses-json
    multipart
    opentelemetry-sdk
    pytest-asyncio
    pytest-httpx
    pytest-socket
    pytest-vcr
    pytestCheckHook
  ];

  # evaluation and external tests require OpenAPI key
  # integration tests are all marked flaky
  enabledTestPaths = [
    "tests/unit_tests"
  ];

  disabledTestMarks = [
    "flaky"
  ];

  disabledTests = [
    # due to circular import
    "test_as_runnable"
    "test_as_runnable_batch"
    "test_as_runnable_async"
    "test_as_runnable_async_batch"
  ];

  disabledTestPaths = [
    # due to circular import
    "tests/unit_tests/test_client.py"
    "tests/unit_tests/evaluation/test_runner.py"

    # google-adk isn't packaged (and has an enormous number of dependencies)
    "tests/unit_tests/wrappers/test_google_adk.py"
  ];

  pythonImportsCheck = [ "langsmith" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Client library to connect to the LangSmith LLM Tracing and Evaluation Platform";
    homepage = "https://github.com/langchain-ai/langsmith-sdk";
    changelog = "https://github.com/langchain-ai/langsmith-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
    mainProgram = "langsmith";
  };
})
