{ lib
, aiodns
, aiohttp
, azure-core
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
  version = "0.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "msrest-for-python";
    # no tag for 0.7.1
    rev = "2d8fd04f68a124d0f3df7b81584accc3270b1afc";
    hash = "sha256-1EXXXflhDeU+erdI+NsWxSX76ooDTl3+MyQwRzm2xV0=";
  };

  propagatedBuildInputs = [
    azure-core
    aiodns
    aiohttp
    certifi
    isodate
    requests
    requests-oauthlib
  ];

  nativeCheckInputs = [
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
