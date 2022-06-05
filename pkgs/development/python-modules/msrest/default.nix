{ lib
, aiodns
, aiohttp
, buildPythonPackage
, certifi
, fetchFromGitHub
, httpretty
, isodate
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, trio
}:

buildPythonPackage rec {
  pname = "msrest";
  version = "0.6.21";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrest-for-python";
    rev = "v${version}";
    hash = "sha256-IlBwlVQ/v+vJmCWNbFZKGL6a9K09z4AYrPm3kwaA/nI=";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
    certifi
    isodate
    requests
    requests-oauthlib
  ];

  checkInputs = [
    httpretty
    pytest-aiohttp
    pytestCheckHook
    trio
  ];

  disabledTests = [
    # Test require network access
    "test_basic_aiohttp"
    "test_basic_aiohttp"
    "test_basic_async_requests"
    "test_basic_async_requests"
    "test_conf_async_requests"
    "test_conf_async_requests"
    "test_conf_async_trio_requests"
  ];

  pythonImportsCheck = [
    "msrest"
  ];

  meta = with lib; {
    description = "The runtime library for AutoRest generated Python clients";
    homepage = "https://github.com/Azure/msrest-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ bendlas jonringer maxwilson ];
  };
}
