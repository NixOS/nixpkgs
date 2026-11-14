{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

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
  cachetools,
  dataclasses-json,
  multipart,
  openai,
  opentelemetry-sdk,
  pyjwt,
  pytest-asyncio,
  pytest-httpx,
  pytest-socket,
  pytest-vcr,
  pytest-xdist,
  pytestCheckHook,
  rich,
}:

buildPythonPackage (finalAttrs: {
  pname = "langsmith";
  version = "0.14.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langsmith-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D/4tbYB3mKk4mlY7HtBtz/m4Iw/NaDZ5AwyiEkuajqE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==" "hatchling>="
  '';

  pythonRelaxDeps = [ "orjson" ];

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

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
    cachetools
    dataclasses-json
    multipart
    openai
    opentelemetry-sdk
    pyjwt
    pytest-asyncio
    pytest-httpx
    pytest-socket
    pytest-vcr
    pytest-xdist
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
    "httpx_mock"

    # flaky
    "test_admission_under_concurrency_never_mixes_destinations"

    # "Invalid http_client" argument
    "test_session_write_uses_v1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky (timing sensitive)
    "test_refresh_loop_continues_after_500_errors"
  ];

  disabledTestPaths = [
    # due to circular import
    "tests/unit_tests/test_client.py"
    "tests/unit_tests/evaluation/test_runner.py"
    "tests/unit_tests/test_otel_exporter.py"

    # google-adk isn't packaged (and has an enormous number of dependencies)
    "tests/unit_tests/wrappers/test_google_adk.py"

    # strands-agents isn't packaged
    "tests/unit_tests/wrappers/test_strands_agents.py"

    # require network access to external test servers
    "tests/unit_tests/test_async_client.py::test_arequest_with_retries_retries_on_502"
    "tests/unit_tests/test_async_client.py::test_async_create_feedback_retries_on_not_found"
    "tests/unit_tests/test_async_client.py::test_create_feedback_retries_on_not_found"

    # AssertionError: mocked responsed were not called
    "tests/unit_tests/sandbox"

    # fragile: fails on schema changes in anthropic api
    "tests/unit_tests/wrappers/test_openai_agents_api.py"
  ];

  pythonImportsCheck = [ "langsmith" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Client library to connect to the LangSmith LLM Tracing and Evaluation Platform";
    homepage = "https://github.com/langchain-ai/langsmith-python";
    changelog = "https://github.com/langchain-ai/langsmith-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
    mainProgram = "langsmith";
  };
})
