{ lib
, brotli
, brotlicffi
, buildPythonPackage
, certifi
, chardet
, charset-normalizer
, fetchPypi
, idna
, pytest-mock
, pytest-xdist
, pytestCheckHook
, urllib3
, isPy27
, isPy3k
, trustme
}:

buildPythonPackage rec {
  pname = "requests";
  version = "2.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uKpY+M95P/2HgtPYyxnmbvNverpDU+7IWedGeLAbB6c=";
  };

  patches = [
    # Use the default NixOS CA bundle from the certifi package
    ./0001-Prefer-NixOS-Nix-default-CA-bundles-over-certifi.patch
  ];

  postPatch = ''
    # Use latest idna
    substituteInPlace setup.py --replace ",<3" ""
  '';

  propagatedBuildInputs = [
    certifi
    idna
    urllib3
    chardet
  ] ++ lib.optionals (isPy3k) [
    brotlicffi
    charset-normalizer
  ] ++ lib.optionals (isPy27) [
    brotli
  ];

  checkInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
    trustme
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
