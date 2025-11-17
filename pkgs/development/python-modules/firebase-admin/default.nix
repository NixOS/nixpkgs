{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cachecontrol,
  cryptography,
  google-api-python-client,
  google-cloud-firestore,
  google-cloud-storage,
  h2,
  httpx,
  pyjwt,
  requests,
  respx,
  pytestCheckHook,
  pytest-asyncio,
  pytest-localserver,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "firebase-admin";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-admin-python";
    tag = "v${version}";
    hash = "sha256-xlKrtH8f9UzY9OGYrpNH0i2OAlcxTrpzPC5JEuL8plM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachecontrol
    cryptography
    google-api-python-client
    google-cloud-firestore
    google-cloud-storage
    httpx
    pyjwt
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-localserver
    pytest-mock
    h2
    respx
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # Flaky (AssertionError)
    # >       assert delta <= timedelta(seconds=15)
    # E       assert datetime.timedelta(seconds=17, microseconds=28239) <= datetime.timedelta(seconds=15)
    "test_task_options"

    # Flaky / timing sensitive
    "test_expired_cookie_with_tolerance"
    "test_expired_token_with_tolerance"
  ];

  meta = {
    description = "Firebase Admin Python SDK";
    homepage = "https://github.com/firebase/firebase-admin-python";
    changelog = "https://github.com/firebase/firebase-admin-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jhahn
      sarahec
    ];
  };
}
