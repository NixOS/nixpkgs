{ lib
, stdenv
<<<<<<< HEAD
, aiohttp
, aioresponses
, buildPythonPackage
=======
, buildPythonPackage
, aiohttp
, aioresponses
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "2.21.0";
=======
  version = "2.17.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-so6ASOV3J+fPDlvY5ydrISrvR2ZUoJURNUqoJ1O0XGY=";
=======
    hash = "sha256-zjEeK8WLEw/d8xbfV8mzlDwqe09uwx3pZjqTM+QGTvw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cachetools
    pyasn1-modules
    rsa
    six
<<<<<<< HEAD
    urllib3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    urllib3
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
