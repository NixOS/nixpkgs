{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  mock,
  pyparsing,
  pysocks,
  pytest-cov-stub,
  pytest-forked,
  pytest-randomly,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "httplib2";
    repo = "httplib2";
    tag = "v${version}";
    hash = "sha256-faeanUBpNmhBEffENP9hl9tnZoRmKf3Fq1s4FdPs8LQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyparsing ];

  nativeCheckInputs = [
    cryptography
    mock
    pysocks
    pytest-cov-stub
    pytest-forked
    pytest-randomly
    pytest-timeout
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # ValueError: Unable to load PEM file.
    # https://github.com/httplib2/httplib2/issues/192#issuecomment-993165140
    "test_client_cert_password_verified"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # fails with "ConnectionResetError: [Errno 54] Connection reset by peer"
    "test_connection_close"
    # fails with HTTP 408 Request Timeout, instead of expected 200 OK
    "test_timeout_subsequent"
    "test_connection_close"
  ];

  pythonImportsCheck = [ "httplib2" ];

  meta = with lib; {
    description = "Comprehensive HTTP client library";
    homepage = "https://github.com/httplib2/httplib2";
    changelog = "https://github.com/httplib2/httplib2/blob/${src.tag}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
