{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build inputs
  requests,
  six,
  monotonic,
  backoff,
  python-dateutil,
  # check inputs
  pytestCheckHook,
  mock,
  freezegun,
}:
let
  pname = "posthog";
  version = "3.5.0";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-+nYMQxqI9RZ5vVL6KgiRLcx0JHWJTs/rZ6U6jIuaz+w=";
  };

  propagatedBuildInputs = [
    requests
    six
    monotonic
    backoff
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    freezegun
  ];

  pythonImportsCheck = [ "posthog" ];

  disabledTests = [
    "test_load_feature_flags_wrong_key"
    # Tests require network access
    "test_request"
    "test_upload"
  ];

  meta = with lib; {
    description = "Official PostHog python library";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
