{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hatchling,
  cachecontrol,
  cryptography,
  google-api-python-client,
  google-cloud-firestore,
  google-cloud-storage,
  pyjwt,
  requests,
  pytestCheckHook,
  pytest-localserver,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "firebase-admin";
  version = "6.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-admin-python";
    tag = "v${version}";
    hash = "sha256-BjYo/H5CBII9KjefhGUiEeLKBAAsnQABX+21R4pR8wE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachecontrol
    cryptography
    google-api-python-client
    google-cloud-firestore
    google-cloud-storage
    pyjwt
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-localserver
    pytest-mock
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # Flaky (AssertionError)
    # >       assert delta <= timedelta(seconds=15)
    # E       assert datetime.timedelta(seconds=17, microseconds=28239) <= datetime.timedelta(seconds=15)
    "test_task_options"
  ];

  meta = {
    description = "Firebase Admin Python SDK";
    homepage = "https://github.com/firebase/firebase-admin-python";
    changelog = "https://github.com/firebase/firebase-admin-python/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jhahn ];
  };
}
