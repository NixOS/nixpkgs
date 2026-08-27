{
  lib,
  anthropic,
  backoff,
  buildPythonPackage,
  claude-agent-sdk,
  distro,
  fastmcp,
  fetchFromGitHub,
  freezegun,
  google-genai,
  langchain,
  mcp,
  mock,
  openai,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,
  parameterized,
  pytest-asyncio,
  pytest-bdd,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  requests,
  setuptools,
  typing-extensions,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "posthog";
  version = "7.44.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "posthog-v${finalAttrs.version}";
    hash = "sha256-co2Q6eW9Z0fcP7b5Uc6hCYsKOUZcgvWMMKnU5mMNo1U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
    distro
    python-dateutil
    requests
    typing-extensions
  ];

  optional-dependencies = {
    langchain = [ langchain ];
    otel = [
      opentelemetry-sdk
      opentelemetry-exporter-otlp-proto-http
    ];
    zstd = [ zstandard ];
  };

  nativeCheckInputs = [
    anthropic
    claude-agent-sdk
    fastmcp
    freezegun
    google-genai
    mcp
    mock
    openai
    parameterized
    pytest-asyncio
    pytest-bdd
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "posthog" ];

  disabledTests = [
    "test_load_feature_flags_wrong_key"
    # Tests require network access
    "test_excepthook"
    "test_request"
    "test_trying_to_use_django_integration"
    "test_upload"
    # AssertionError: 2 != 3
    "test_flush_interval"
    # len(client.distinct_ids_feature_flags_reported) = 101 != i % 100 + 1
    "test_capture_multiple_users_doesnt_out_of_memory"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # Pydantic V1 functionality isn't compatible with Python 3.14
    "test_clean_pydantic"
  ];

  disabledTestPaths = [
    # Missing parts
    "posthog/test/integrations/test_middleware.py"
  ];

  meta = {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
