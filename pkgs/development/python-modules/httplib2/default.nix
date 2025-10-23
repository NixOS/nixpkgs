{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mock,
  pyparsing,
  pytest-cov-stub,
  pytest-forked,
  pytest-randomly,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  six,
}:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.22.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "httplib2";
    repo = "httplib2";
    rev = "v${version}";
    hash = "sha256-76gdiRbF535CEaNXwNqsVeVc0dKglovMPQpGsOkbd/4=";
  };

  propagatedBuildInputs = [ pyparsing ];

  nativeCheckInputs = [
    cryptography
    mock
    pytest-cov-stub
    pytest-forked
    pytest-randomly
    pytest-timeout
    six
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  # Don't run tests for older Pythons
  doCheck = pythonAtLeast "3.9";

  disabledTests = [
    # ValueError: Unable to load PEM file.
    # https://github.com/httplib2/httplib2/issues/192#issuecomment-993165140
    "test_client_cert_password_verified"

    # improper pytest marking
    "test_head_301"
    "test_303"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails with "ConnectionResetError: [Errno 54] Connection reset by peer"
    "test_connection_close"
    # fails with HTTP 408 Request Timeout, instead of expected 200 OK
    "test_timeout_subsequent"
    "test_connection_close"
  ];

  disabledTestPaths = [ "python2" ];

  pythonImportsCheck = [ "httplib2" ];

  meta = with lib; {
    description = "Comprehensive HTTP client library";
    homepage = "https://github.com/httplib2/httplib2";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
