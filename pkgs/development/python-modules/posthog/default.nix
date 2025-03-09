{
  lib,
  anthropic,
  backoff,
  buildPythonPackage,
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
  version = "3.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "v${version}";
    hash = "sha256-1jJACzDf8J4Vsrvtj0PgeK1Ck2Bzy5ThHm0Ohd+LyYs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    backoff
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

  meta = with lib; {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
