{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cachecontrol,
  cryptography,
  google-api-python-client,
  google-cloud-firestore,
  google-cloud-storage,
  pyjwt,
  requests,
  pytestCheckHook,
  pytest-asyncio,
  pytest-localserver,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "firebase-admin";
  version = "6.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-admin-python";
    tag = "v${version}";
    hash = "sha256-N8DidHocdIV5qFEPZIqWZPfxvIfJzd/+jXGk/OZBT1s=";
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
    pytest-asyncio
    pytest-localserver
    pytest-mock
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests =
    [
      # Flaky (AssertionError)
      # >       assert delta <= timedelta(seconds=15)
      # E       assert datetime.timedelta(seconds=17, microseconds=28239) <= datetime.timedelta(seconds=15)
      "test_task_options"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
