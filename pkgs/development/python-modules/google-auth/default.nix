{
  lib,
  stdenv,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  cachetools,
  cryptography,
  fetchPypi,
  flask,
  freezegun,
  grpcio,
  mock,
  oauth2client,
  pyasn1-modules,
  pyjwt,
  pyopenssl,
  pytest-asyncio,
  pytest-localserver,
  pytestCheckHook,
  pythonOlder,
  pyu2f,
  requests,
  responses,
  rsa,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.37.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_auth";
    inherit version;
    hash = "sha256-AFRiOr8fnINJLGPT9H538KVEyqPUCy2Y4JmmEcLdXQA=";
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

  nativeCheckInputs =
    [
      aioresponses
      flask
      freezegun
      grpcio
      mock
    ]
    ++ lib.optionals (pythonOlder "3.13") [
      oauth2client
    ]
    ++ [
      pytest-asyncio
      pytest-localserver
      pytestCheckHook
      responses
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  pytestFlagsArray = [
    # cryptography 44 compat issue
    "--deselect=tests/transport/test__mtls_helper.py::TestDecryptPrivateKey::test_success"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google's various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
