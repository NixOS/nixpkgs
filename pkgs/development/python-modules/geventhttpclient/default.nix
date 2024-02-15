{ lib
, brotli
, buildPythonPackage
, certifi
, dpkt
, fetchPypi
, gevent
, pytestCheckHook
, pythonOlder
, six
, stdenv
, urllib3
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "2.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VJ0POvCEILmtK+7aIRFTx2BbW6QJsijbfxuByL++xrQ=";
  };

  propagatedBuildInputs = [
    brotli
    certifi
    gevent
    six
  ];

  nativeCheckInputs = [
    dpkt
    pytestCheckHook
    urllib3
  ];

  # lots of: [Errno 48] Address already in use: ('127.0.0.1', 54323)
  doCheck = !stdenv.isDarwin;

  __darwinAllowLocalNetworking = true;

  disabledTests = [
    # socket.gaierror: [Errno -3] Temporary failure in name resolution
    "test_client_simple"
    "test_client_without_leading_slas"
    "test_request_with_headers"
    "test_response_context_manager"
    "test_client_ssl"
    "test_ssl_fail_invalid_certificate"
    "test_multi_queries_greenlet_safe"
  ];

  pythonImportsCheck = [
    "geventhttpclient"
  ];

  meta = with lib; {
    homepage = "https://github.com/geventhttpclient/geventhttpclient";
    description = "High performance, concurrent HTTP client library using gevent";
    changelog = "https://github.com/geventhttpclient/geventhttpclient/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
