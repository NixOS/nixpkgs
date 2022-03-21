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
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "1.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2A7J/0K3IZ8zVYGFSZ0LQ2VZf8Vf+IYge0X1Yy4Jl4A=";
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
  ];

  disabledTests = [
    # socket.gaierror: [Errno -2] Name or service not known
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
    homepage = "https://github.com/gwik/geventhttpclient";
    description = "HTTP client library for gevent";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };
}
