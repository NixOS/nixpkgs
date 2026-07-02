{
  lib,
  fetchFromGitHub,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  cryptography,
  flask,
  freezegun,
  gitUpdater,
  grpcio,
  mock,
  packaging,
  pyasn1-modules,
  pyjwt,
  pyopenssl,
  pytest-asyncio,
  pytest-localserver,
  pytestCheckHook,
  pyu2f,
  requests,
  responses,
  rsa,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.50.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-auth-v${version}";
    hash = "sha256-Z3TsDEtDDfXO23gOlmEM5O4a9qS2+fTB7g0vJ4dOFH4=";
  };

  sourceRoot = "${src.name}/packages/google-auth";

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    pyasn1-modules
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      requests
    ];
    cryptography = [ cryptography ];
    enterprise_cert = [
      pyopenssl
    ];
    pyopenssl = [
      pyopenssl
    ];
    pyjwt = [
      pyjwt
    ];
    reauth = [ pyu2f ];
    requests = [ requests ];
    rsa = [ rsa ];
    urllib3 = [
      packaging
      urllib3
    ];
  };

  pythonRelaxDeps = [ "cachetools" ];

  nativeCheckInputs = [
    aioresponses
    flask
    freezegun
    grpcio
    mock
    pytest-asyncio
    pytest-localserver
    pytestCheckHook
    responses
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    "system_tests/"

    # cryptography 44 compat issue
    "tests/transport/test__mtls_helper.py::TestDecryptPrivateKey::test_success"
  ];

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "google-auth-v";
  };

  meta = {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google's various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-auth";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-auth/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
