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
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-1evqG/rdHBs0bAHM+bIHyT4tFE6tAE+aJyu5r0QqAMk=";
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
  ];

  meta = with lib; {
    description = "Module for interacting with PostHog";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
