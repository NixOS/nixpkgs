{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,

  setuptools,
  setuptools-scm,
  pyyaml,
  aiohttp,
  iso8601,
  python-json-logger,
  click,

  jsonpatch,
  kmock,
  pytest-mock,
  pytest-timeout,
  pytest-asyncio,
  pyngrok,
  freezegun,
  certvalidator,
  aresponses,
  looptime,
}:

buildPythonPackage (finalAttrs: {
  pname = "kopf";
  version = "1.45.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nolar";
    repo = "kopf";
    tag = finalAttrs.version;
    hash = "sha256-ffBdauplO1WkrXcsJuCKBhlkXpoinFqRU24uSoDQIm0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    pyyaml
    python-json-logger
    aiohttp
    iso8601
    jsonpatch
    click
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyngrok
    pytest-timeout
    pytest-asyncio
    pytest-mock
    kmock
    freezegun
    certvalidator
    aresponses
    looptime
  ];

  disabledTestPaths = [
    # Module astpath unavailable in nixpkgs
    "tests/admission/test_certificates.py"
    "tests/e2e/test_examples.py"

    # Module certbuilder unavailable in nixpkgs
    "tests/admission/test_webhook_detection.py"
    "tests/admission/test_webhook_ngrok.py"
    "tests/admission/test_webhook_server.py"
    "tests/authentication/test_credentials.py"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "tests/posting/test_threadsafety.py";

  disabledTests = [
    # assert [] to due missing certificate
    "test_connection_info_as_ssl_context_when_insecure"
  ];

  pytestFlags = [
    "-Wignore::pytest.PytestUnraisableExceptionWarning"
    "-Wignore::DeprecationWarning"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "kopf"
  ];

  meta = {
    description = "Python framework to write Kubernetes operators";
    homepage = "https://kopf.readthedocs.io/";
    changelog = "https://github.com/nolar/kopf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
  };
})
