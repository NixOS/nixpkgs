{
  lib,
  fetchFromGitHub,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  cachetools,
  cryptography,
  flask,
  freezegun,
  grpcio,
  mock,
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
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.40.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-auth-library-python";
    tag = "v${version}";
    hash = "sha256-jO6brNdTH8BitLKKP/nwrlUo5hfQnThT/bPbzefvRbM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    pyasn1-modules
    rsa
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      requests
    ];
    enterprise_cert = [
      cryptography
      pyopenssl
    ];
    pyopenssl = [
      cryptography
      pyopenssl
    ];
    pyjwt = [
      cryptography
      pyjwt
    ];
    reauth = [ pyu2f ];
    requests = [ requests ];
  };

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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    "samples/"
    "system_tests/"
    # Requires a running aiohttp event loop
    "tests_async/"
  ];

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  pytestFlagsArray = [
    # cryptography 44 compat issue
    "--deselect=tests/transport/test__mtls_helper.py::TestDecryptPrivateKey::test_success"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google's various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
