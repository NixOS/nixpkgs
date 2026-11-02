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
  pytest9_1CheckHook,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "httplib2";
  version = "0.32.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "httplib2";
    repo = "httplib2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OK480dK4/n51OrW116FNv+EC37JFZMAK/nnIrG1R5ig=";
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
    six
    pytest9_1CheckHook
  ];

  __darwinAllowLocalNetworking = true;

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

  pythonImportsCheck = [ "httplib2" ];

  meta = {
    changelog = "https://github.com/httplib2/httplib2/blob/${finalAttrs.src.tag}/CHANGELOG";
    description = "Comprehensive HTTP client library";
    homepage = "https://github.com/httplib2/httplib2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
