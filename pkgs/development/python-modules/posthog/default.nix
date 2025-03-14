{
  lib,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  mock,
  monotonic,
  openai,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "posthog";
  version = "3.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    tag = "v${version}";
    hash = "sha256-s4MVpJb5sRe4TIW9Bb068JTnUkObGOG3VlbWVuPPTM4=";
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
    freezegun
    mock
    openai
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
    changelog = "https://github.com/PostHog/posthog-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
