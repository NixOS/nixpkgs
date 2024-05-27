{
  lib,
  stdenv,
  brotlicffi,
  buildPythonPackage,
  certifi,
  chardet,
  charset-normalizer,
  fetchPypi,
  idna,
  pysocks,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  urllib3,
}:

buildPythonPackage rec {
  pname = "requests";
  version = "2.31.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lCxadY+Y15Dq7Ropy27vx/+w0c968Fw9J5Flbb1q0eE=";
  };

  dependencies = [
    brotlicffi
    certifi
    charset-normalizer
    idna
    urllib3
  ];

  optional-dependencies = {
    security = [ ];
    socks = [ pysocks ];
    use_chardet_on_py3 = [ chardet ];
  };

  nativeCheckInputs = [
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ] ++ optional-dependencies.socks;

  disabledTests =
    [
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
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      # Fatal Python error: Aborted
      "test_basic_response"
      "test_text_response"
    ];

  disabledTestPaths = lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # Fatal Python error: Aborted
    "tests/test_lowlevel.py"
  ];

  pythonImportsCheck = [ "requests" ];

  meta = with lib; {
    description = "HTTP library for Python";
    homepage = "http://docs.python-requests.org/";
    changelog = "https://github.com/psf/requests/blob/v${version}/HISTORY.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
