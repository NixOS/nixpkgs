{
  lib,
  anthropic,
  backoff,
  buildPythonPackage,
  distro,
  django,
  fetchFromGitHub,
  freezegun,
  google-genai,
  mcp,
  mock,
  monotonic,
  openai,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
  parameterized,
  pytest-asyncio,
  pytest-bdd,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  requests,
  setuptools,
  six,
  typing-extensions,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "posthog";
  version = "7.45.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-UZqfNc8u0sG6G0YCzKeoWfwKIASgtmsKRJISjyGyULw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
    distro
    monotonic
    python-dateutil
    requests
    six
    typing-extensions
  ];

  nativeCheckInputs = [
    anthropic
    django
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
  ];

  meta = {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
