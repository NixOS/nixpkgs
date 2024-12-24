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
  version = "2.36.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_auth";
    inherit version;
    hash = "sha256-VF6WGPLfC8u33LxFpUZIWxISYkcWl1oepa6BSc52mrE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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
      oauth2client
      pytest-asyncio
      pytest-localserver
      pytestCheckHook
      responses
    ]
    ++ optional-dependencies.aiohttp
    ++ optional-dependencies.enterprise_cert
    ++ optional-dependencies.reauth;

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  pytestFlagsArray = [
    # cryptography 44 compat issue
    "--deselect=tests/transport/test__mtls_helper.py::TestDecryptPrivateKey::test_success"
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    # Disable tests using pyOpenSSL as it does not build on M1 Macs
    "tests/transport/test__mtls_helper.py"
    "tests/transport/test_requests.py"
    "tests/transport/test_urllib3.py"
    "tests/transport/test__custom_tls_signer.py"
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
