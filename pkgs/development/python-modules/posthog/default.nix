{
  lib,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  mock,
  monotonic,
  pytestCheckHook,
  python-dateutil,
  requests,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "posthog";
  version = "3.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-43ySHV2Idssd5YonzhyIpet98vinpQ4O2AKUiAlYahY=";
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
    changelog = "https://github.com/PostHog/posthog-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
