{
  lib,
  anthropic,
  backoff,
  buildPythonPackage,
  distro,
  django,
  djangorestframework,
  fetchFromGitHub,
  flask,
  freezegun,
  google-genai,
  mcp,
  mock,
  openai,
  opentelemetry-exporter-otlp,
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
  version = "7.71.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-4sc1PZaN/SdUk/akzyHhuPejUEDYyXuHlBxIw2LYOaA=";
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
    django
    djangorestframework
    flask
    freezegun
    google-genai
    mcp
    mock
    openai
    opentelemetry-exporter-otlp
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
