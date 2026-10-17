{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  distro,
  httpx2,
  orjson,
  pydantic,
  requests,
  requests-toolbelt,
  sniffio,
  typing-extensions,
  uuid-utils,
  websockets,
  xxhash,
  zstandard,

  # tests
  anthropic,
  cachetools,
  dataclasses-json,
  multipart,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-httpx,
  pytest-socket,
  pytest-vcr,
  pytestCheckHook,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "langsmith";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e5+lttn90eBL4xkvxN9oH3aPp1wRBfy5Q0pS8LDCiq8=";
  };

  sourceRoot = "${finalAttrs.src.name}/python";

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ hatchling ];

  dependencies = [
    anyio
    distro
    httpx2
    orjson
    pydantic
    requests
    requests-toolbelt
    sniffio
    typing-extensions
    uuid-utils
    websockets
    xxhash
    zstandard
  ];

  nativeCheckInputs = [
    anthropic
    cachetools
    dataclasses-json
    multipart
    opentelemetry-sdk
    pytest-asyncio
    pytest-httpx
    pytest-socket
    pytest-vcr
    pytestCheckHook
    rich
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky (timing sensitive)
    "test_refresh_loop_continues_after_500_errors"
  ];

  disabledTestPaths = [
    # due to circular import
    "tests/unit_tests/test_client.py"
    "tests/unit_tests/evaluation/test_runner.py"

    # google-adk isn't packaged (and has an enormous number of dependencies)
    "tests/unit_tests/wrappers/test_google_adk.py"

    # strands-agents isn't packaged
    "tests/unit_tests/wrappers/test_strands_agents.py"

    # require network access to external test servers
    "tests/unit_tests/test_async_client.py::test_arequest_with_retries_retries_on_502"
    "tests/unit_tests/test_async_client.py::test_async_create_feedback_retries_on_not_found"
    "tests/unit_tests/test_async_client.py::test_create_feedback_retries_on_not_found"
    "tests/unit_tests/sandbox/test_async_client.py::TestAsyncConnectionErrors"
    "tests/unit_tests/sandbox/test_async_client.py::TestAsyncSandboxOperations"
    "tests/unit_tests/sandbox/test_async_client.py::TestAsyncSnapshotTags"
    "tests/unit_tests/sandbox/test_async_client.py::TestGenerateDownloadURL"
    "tests/unit_tests/sandbox/test_async_client.py::TestService"
    "tests/unit_tests/sandbox/test_async_sandbox.py::TestAsyncSandboxContextManager"
    "tests/unit_tests/sandbox/test_async_sandbox.py::TestAsyncSandboxRead"
    "tests/unit_tests/sandbox/test_async_sandbox.py::TestAsyncSandboxRun"
    "tests/unit_tests/sandbox/test_async_sandbox.py::TestAsyncSandboxStatusFields"
    "tests/unit_tests/sandbox/test_async_sandbox.py::TestAsyncSandboxWrite"
    "tests/unit_tests/sandbox/test_client.py::TestConnectionErrors"
    "tests/unit_tests/sandbox/test_client.py::TestGenerateDownloadURL"
    "tests/unit_tests/sandbox/test_client.py::TestRegistries"
    "tests/unit_tests/sandbox/test_client.py::TestSandboxOperations"
    "tests/unit_tests/sandbox/test_client.py::TestService"
    "tests/unit_tests/sandbox/test_client.py::TestSnapshotOperations"
    "tests/unit_tests/sandbox/test_client.py::TestStartStopOperations"
    "tests/unit_tests/sandbox/test_proxy_config.py::test_create_sandbox_expands_mount_config"
    "tests/unit_tests/sandbox/test_proxy_config.py::test_create_sandbox_forwards_composed_proxy_config"
    "tests/unit_tests/sandbox/test_proxy_config.py::test_create_sandbox_preserves_mount_config_and_proxy_config_separately"
    "tests/unit_tests/sandbox/test_sandbox.py::TestSandboxContextManager"
    "tests/unit_tests/sandbox/test_sandbox.py::TestSandboxRead"
    "tests/unit_tests/sandbox/test_sandbox.py::TestSandboxRun"
    "tests/unit_tests/sandbox/test_sandbox.py::TestSandboxStatusFields"
    "tests/unit_tests/sandbox/test_sandbox.py::TestSandboxWrite"
    "tests/unit_tests/sandbox/test_transport.py::TestAsyncRetryTransport"
    "tests/unit_tests/sandbox/test_transport.py::TestRetryTransport"
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
