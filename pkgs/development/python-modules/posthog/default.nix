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
  ];

  meta = {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${finalAttrs.src.tag}/posthog/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
