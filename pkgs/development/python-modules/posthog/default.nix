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
  version = "7.89.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-wyMGfm3RxeV2jAFWqS071/pYxwFwwUakncfKXs1EJt0=";
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

    # ModuleNotFoundError: No module named 'langchain_core'
    "test_langchain_privacy_mode_sends_no_content_or_exception_event"

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
