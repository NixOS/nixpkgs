{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
# build inputs
, requests
, six
, monotonic
, backoff
, python-dateutil
# check inputs
, mock
, freezegun
, pylint
, flake8
, coverage
, pytest
}:
let
  pname = "posthog";
  version = "3.0.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PostHog";
    repo = "posthog-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-GSHsa05DUcbIHg1HCoIn8d4NZoG+Iddqfgod2nP4fX0=";
  };

  propagatedBuildInputs = [
    requests
    six
    monotonic
    backoff
    python-dateutil
  ];

  nativeCheckInputs = [
    mock
    freezegun
    pylint
    flake8
    coverage
    pytest
  ];

  pythonImportsCheck = [
    "posthog"
  ];

  meta = with lib; {
    description = "Official PostHog python library";
    homepage = "https://github.com/PostHog/posthog-python";
    changelog = "https://github.com/PostHog/posthog-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
