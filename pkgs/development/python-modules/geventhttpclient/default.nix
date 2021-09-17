{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, backports_ssl_match_hostname
, brotli
, certifi
, gevent
, six
, dpkt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "geventhttpclient";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4aead64253d2769a6528544f7812ce8d71ae13551d079f2d9a3533d72818f2e0";
  };

  propagatedBuildInputs = [
    brotli
    certifi
    gevent
    six
  ] ++ lib.optionals (pythonOlder "3.7") [
    backports_ssl_match_hostname
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

  meta = with lib; {
    homepage = "https://github.com/gwik/geventhttpclient";
    description = "HTTP client library for gevent";
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
  };

}
