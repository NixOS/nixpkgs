{ lib
, stdenv
, aiohttp
, aioresponses
, buildPythonPackage
, cachetools
, cryptography
, fetchPypi
, flask
, freezegun
, grpcio
, mock
, oauth2client
, pyasn1-modules
, pyopenssl
, pytest-asyncio
, pytest-localserver
, pytestCheckHook
, pythonOlder
, pyu2f
, requests
, responses
, rsa
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-so6ASOV3J+fPDlvY5ydrISrvR2ZUoJURNUqoJ1O0XGY=";
  };

  propagatedBuildInputs = [
    cachetools
    pyasn1-modules
    rsa
    six
    urllib3
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
      requests
    ];
    enterprise_cert = [
      cryptography
      pyopenssl
    ];
    pyopenssl = [
      pyopenssl
    ];
    reauth = [
      pyu2f
    ];
    requests = [
      requests
    ];
  };

  nativeCheckInputs = [
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
  ] ++ passthru.optional-dependencies.aiohttp
  # `cryptography` is still required on `aarch64-darwin` for `tests/crypt/*`
  ++ (if (stdenv.isDarwin && stdenv.isAarch64) then [ cryptography ] else passthru.optional-dependencies.enterprise_cert)
  ++ passthru.optional-dependencies.reauth;

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
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
    maintainers = with maintainers; [ ];
  };
}
