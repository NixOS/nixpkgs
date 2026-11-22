{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  backoff,
  distro,
  requests,
  typing-extensions,

  # tests
  anthropic,
  celery,
  django,
  djangorestframework,
  fastapi,
  flask,
  freezegun,
  google-genai,
  griffe,
  langchain-core,
  mcp,
  mock,
  openai,
  opentelemetry-exporter-otlp,
  opentelemetry-instrumentation-celery,
  opentelemetry-sdk,
  parameterized,
  pytest-asyncio,
  pytest-bdd,
  pytestCheckHook,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "posthog";
  version = "7.91.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-RfeCKz36+NTC08Y29KQ3Dz+TBzh4zD6opGw6sI04bPw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
    distro
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    anthropic
    celery
    django
    djangorestframework
    fastapi
    flask
    freezegun
    google-genai
    griffe
    langchain-core
    mcp
    mock
    openai
    opentelemetry-exporter-otlp
    opentelemetry-instrumentation-celery
    opentelemetry-sdk
    parameterized
    pytest-asyncio
    pytest-bdd
    pytestCheckHook
    zstandard
  ];

  pythonImportsCheck = [ "posthog" ];

  disabledTests = [
    # Tests require network access
    "test_excepthook"
    "test_request"
    "test_upload"

    # Timing-sensitive: the worker subprocess times out under load
    "test_capture_from_worker_thread_wakes_loop_bound_queue"
  ];

  disabledTestPaths = [
    # Requires many opentelemetry-instrumentation-* packages
    "posthog/test/test_metrics_autocapture.py"
  ];

  __darwinAllowLocalNetworking = true; # for the transport tests

  meta = {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${finalAttrs.src.tag}/posthog/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
