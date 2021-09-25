{ stdenv
, lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, pytestCheckHook
, cachetools
, flask
, freezegun
, mock
, oauth2client
, pyasn1-modules
, pyu2f
, pytest-localserver
, responses
, rsa
, pyopenssl
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6hrwULPgbrc+RHD3BNIwBzB7wOh8E+AV9rkEYPFAe9M=";
  };

  propagatedBuildInputs = [
    cachetools
    pyasn1-modules
    rsa
    pyopenssl
    pyu2f
  ];

  checkInputs = [
    flask
    freezegun
    mock
    oauth2client
    pytestCheckHook
    pytest-localserver
    responses
  ];

  pythonImportsCheck = [
    "google.auth"
    "google.oauth2"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_request_with_timeout_success"
    "test_request_with_timeout_failure"
    "test_request_headers"
    "test_request_error"
    "test_request_basic"
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
