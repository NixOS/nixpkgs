{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, maxminddb
, mocket
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, requests
, requests-mock
, urllib3
}:

buildPythonPackage rec {
  pname = "geoip2";
  version = "4.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O93kmU9ryRfq+rW1Hnctc3sq4AA3pbhQAfsG3Gj3ed8=";
  };

  propagatedBuildInputs = [
    aiohttp
    maxminddb
    requests
    urllib3
  ];

  nativeCheckInputs = [
    mocket
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "geoip2"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/maxmind/GeoIP2-python/pull/136
    "TestAsyncClient"
  ] ++ lib.optionals (pythonAtLeast "3.10") [
    "test_request"
  ];

  meta = with lib; {
    description = "GeoIP2 webservice client and database reader";
    homepage = "https://github.com/maxmind/GeoIP2-python";
    changelog = "https://github.com/maxmind/GeoIP2-python/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
