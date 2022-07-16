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
, urllib3
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "1.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H0+XP7n2r+TO7BOdXV2BmbVzM3Gm0uzAZeJXyBAgU5s=";
  };

  propagatedBuildInputs = [
    brotli
    certifi
    gevent
    six
  ];

  checkInputs = [
    dpkt
    pytestCheckHook
    urllib3
  ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
