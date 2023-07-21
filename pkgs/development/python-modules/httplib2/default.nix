{ lib
, stdenv
, buildPythonPackage
, cryptography
, fetchFromGitHub
, isPy27
, mock
, pyparsing
, pytest-forked
, pytest-randomly
, pytest-timeout
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.20.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eLvxmG9PUX+2RB3M6oG442Wmh6c5GI/aKP/Z8Z5Ixq8=";
  };

  propagatedBuildInputs = [
    pyparsing
  ];

  checkInputs = [
    cryptography
    mock
    pytest-forked
    pytest-randomly
    pytest-timeout
    six
    pytestCheckHook
  ];

  # Don't run tests for Python 2.7
  doCheck = !isPy27;

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  disabledTests = [
    # ValueError: Unable to load PEM file.
    # https://github.com/httplib2/httplib2/issues/192#issuecomment-993165140
    "test_client_cert_password_verified"

    # improper pytest marking
    "test_head_301"
    "test_303"
  ] ++ lib.optionals stdenv.isDarwin [
    # fails with "ConnectionResetError: [Errno 54] Connection reset by peer"
    "test_connection_close"
    # fails with HTTP 408 Request Timeout, instead of expected 200 OK
    "test_timeout_subsequent"
    "test_connection_close"
  ];

  pytestFlagsArray = [
    "--ignore python2"
  ];

  pythonImportsCheck = [
    "httplib2"
  ];

  meta = with lib; {
    description = "A comprehensive HTTP client library";
    homepage = "https://github.com/httplib2/httplib2";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
