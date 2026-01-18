{
  lib,
  stdenv,
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
  zstandard,

  # tests
  anthropic,
  attrs,
  dataclasses-json,
  multipart,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-socket,
  pytest-vcr,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langsmith";
  version = "0.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-sdk";
    tag = "v${version}";
    hash = "sha256-325A2kEx2UrykxVRzp6WQCPrg92Vy+6R1CfgnCLV2V8=";
  };

  sourceRoot = "${src.name}/python";

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ hatchling ];

  dependencies = [
    httpx
    orjson
    pydantic
    requests
    requests-toolbelt
    uuid-utils
    zstandard
  ];

  nativeCheckInputs = [
    anthropic
    attrs
    dataclasses-json
    opentelemetry-sdk
    pytest-asyncio
    multipart
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
    # flaky time comparisons
    # https://github.com/langchain-ai/langsmith-sdk/issues/2245
    "tests/unit_tests/test_uuid_v7.py"
  ];

  pythonImportsCheck = [ "langsmith" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Client library to connect to the LangSmith LLM Tracing and Evaluation Platform";
    homepage = "https://github.com/langchain-ai/langsmith-sdk";
    changelog = "https://github.com/langchain-ai/langsmith-sdk/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
    mainProgram = "langsmith";
  };
}
