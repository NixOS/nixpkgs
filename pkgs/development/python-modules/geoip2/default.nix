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
<<<<<<< HEAD
  version = "4.7.0";
=======
  version = "4.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-O93kmU9ryRfq+rW1Hnctc3sq4AA3pbhQAfsG3Gj3ed8=";
=======
    hash = "sha256-8OgLzoCwa7OL0Iv0h31ahONU6TIJXmzPtNJ7tZj6T4M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
