{
  lib,
  anthropic,
  backoff,
  buildPythonPackage,
  celery,
  distro,
  django,
  djangorestframework,
  fastapi,
  fetchFromGitHub,
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
  pythonAtLeast,
  requests,
  setuptools,
  typing-extensions,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "posthog";
  version = "7.75.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-oGq4IBeOpJ9PTy0HHHCfeDYLImhQIyRega3ZwREumHE=";
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

    # AttributeError: 'CallToolResult' object has no attribute 'structuredContent'
    # (mcp>=2 renamed the field to `structured_content`)
    "test_prepare_tool_result_delivers_into_call_tool_result_models"

    # ModuleNotFoundError: No module named 'langchain_core'
    "test_langchain_privacy_mode_sends_no_content_or_exception_event"

    # Timing-sensitive: the worker subprocess times out under load
    "test_capture_from_worker_thread_wakes_loop_bound_queue"
  ];

  meta = {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${finalAttrs.src.tag}/posthog/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
