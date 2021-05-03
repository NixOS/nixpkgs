{ lib
, buildPythonPackage
, certifi
, chardet
, fetchPypi
, idna
, pytest-mock
, pytest-xdist
, pytestCheckHook
, urllib3
, isPy27
}:

buildPythonPackage rec {
  pname = "requests";
  version = "2.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-J5c91KkEpPE7JjoZyGbBO5KjntHJZGVfAl8/jT11uAQ=";
  };

  postPatch = ''
    # Use latest idna
    substituteInPlace setup.py --replace ",<3" ""
  '';

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    urllib3
  ];

  checkInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  # AttributeError: 'KeywordMapping' object has no attribute 'get'
  doCheck = !isPy27;

  disabledTests = [
    # Disable tests that require network access and use httpbin
    "requests.api.request"
    "requests.models.PreparedRequest"
    "requests.sessions.Session"
    "requests"
    "test_redirecting_to_bad_url"
    "test_requests_are_updated_each_time"
    "test_should_bypass_proxies_pass_only_hostname"
    "test_urllib3_pool_connection_closed"
    "test_urllib3_retries"
    "test_use_proxy_from_environment"
    "TestRequests"
    "TestTimeout"
  ];

  pythonImportsCheck = [ "requests" ];

  meta = with lib; {
    description = "Simple HTTP library for Python";
    homepage = "http://docs.python-requests.org/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
