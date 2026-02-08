{
  lib,
  anthropic,
  backoff,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  freezegun,
  mock,
  monotonic,
  openai,
  parameterized,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  requests,
  setuptools,
  six,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "posthog";
  version = "7.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JDt4lLocX+i1WAuY1SUqzmGX5Mt0CcktAsyuGSsTs6Y=";
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
    freezegun
    mock
    openai
    parameterized
    pytest-asyncio
    pytestCheckHook
  ];

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
