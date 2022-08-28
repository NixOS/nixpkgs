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
  version = "2.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7WXs+faBgyKY4pMo4e8KNnbjcysuVvQVMtRfcKIt4Ps=";
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
  };

  checkInputs = [
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
  ++ passthru.optional-dependencies.enterprise_cert
  ++ passthru.optional-dependencies.reauth;

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  disabledTestPaths = [
    # Disable tests related to pyopenssl
    "tests/transport/test__mtls_helper.py"
    "tests/transport/test_requests.py"
    "tests/transport/test_urllib3.py"
  ];

  meta = with lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google’s various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
