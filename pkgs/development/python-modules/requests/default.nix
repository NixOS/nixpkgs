{ lib
, stdenv
, brotli
, brotlicffi
, buildPythonPackage
, certifi
, chardet
, charset-normalizer
, fetchPypi
, idna
, isPy27
, isPy3k
, pysocks
, pytest-mock
, pytest-xdist
, pytestCheckHook
, urllib3
}:

buildPythonPackage rec {
  pname = "requests";
  version = "2.27.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aNfFb9WomZiHco7zBKbRLtx7508c+kdxT8i0FFJcmmE=";
  };

  patches = [
    # Use the default NixOS CA bundle from the certifi package
    ./0001-Prefer-NixOS-Nix-default-CA-bundles-over-certifi.patch
  ];

  propagatedBuildInputs = [
    certifi
    idna
    urllib3
    chardet
  ] ++ lib.optionals isPy3k [
    brotlicffi
    charset-normalizer
  ] ++ lib.optionals isPy27 [
    brotli
  ];

  checkInputs = [
    pysocks
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
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Fatal Python error: Aborted
    "test_basic_response"
    "test_text_response"
  ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Fatal Python error: Aborted
    "tests/test_lowlevel.py"
  ];

  pythonImportsCheck = [
    "requests"
  ];

  meta = with lib; {
    description = "HTTP library for Python";
    homepage = "http://docs.python-requests.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
