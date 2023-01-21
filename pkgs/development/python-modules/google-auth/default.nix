{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, cachetools
, pyasn1-modules
, rsa
, six
, aiohttp
, cryptography
, pyopenssl
, pyu2f
, requests
, pythonOlder
, aioresponses
, asynctest
, flask
, freezegun
, grpcio
, mock
, oauth2client
, pytest-asyncio
, pytest-localserver
, pytestCheckHook
, responses
, urllib3
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cvEqbPyWjXVNe9qzacXFwWAyEG5S0yxt/YSE5MAabR8=";
  };

  propagatedBuildInputs = [
    cachetools
    pyasn1-modules
    rsa
    six
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
    asynctest
    flask
    freezegun
    grpcio
    mock
    oauth2client
    pytest-asyncio
    pytest-localserver
    pytestCheckHook
    responses
    urllib3
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

  meta = with lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google's various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
