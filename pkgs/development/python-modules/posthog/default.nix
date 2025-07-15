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
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "posthog";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "v${version}";
    hash = "sha256-6ZSQFcwuHDgCv301D/7/3QjF9+ZaxXPItvoA+6x0O4U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
    distro
    monotonic
    python-dateutil
    requests
    six
  ];

  nativeCheckInputs = [
    anthropic
    freezegun
    mock
    openai
    parameterized
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
  ];

  disabledTestPaths = [
    # Revisit this at the next version bump, issue open upstream
    # See https://github.com/PostHog/posthog-python/issues/234
    "posthog/test/ai/openai/test_openai.py"
  ];

  meta = {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
