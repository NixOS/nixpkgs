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
  langchain-core,
  mcp,
  openai,
  opentelemetry-exporter-otlp,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-aiohttp-client,
  opentelemetry-instrumentation-celery,
  opentelemetry-instrumentation-django,
  opentelemetry-instrumentation-flask,
  opentelemetry-instrumentation-httpx,
  opentelemetry-instrumentation-requests,
  opentelemetry-instrumentation-sqlite3,
  opentelemetry-instrumentation-system-metrics,
  opentelemetry-sdk,
  parameterized,
  pytest-asyncio,
  pytest-bdd,
  pytestCheckHook,
  requests,
  setuptools,
  typing-extensions,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "posthog";
  version = "7.81.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-Qeo4ZJ1EfgFNJW6a0u8ulU8VmRWrTn+UQS544Cwy3OI=";
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
    langchain-core
    mcp
    openai
    opentelemetry-exporter-otlp
    opentelemetry-instrumentation
    opentelemetry-instrumentation-aiohttp-client
    opentelemetry-instrumentation-celery
    opentelemetry-instrumentation-django
    opentelemetry-instrumentation-flask
    opentelemetry-instrumentation-httpx
    opentelemetry-instrumentation-requests
    opentelemetry-instrumentation-sqlite3
    opentelemetry-instrumentation-system-metrics
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
  ];

  meta = {
    broken = lib.versionAtLeast mcp.version "2";
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${finalAttrs.src.tag}/posthog/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
