{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, dateparser
, fetchFromGitHub
, haversine
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "aio-georss-client";
  version = "0.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-client";
    rev = "v${version}";
    sha256 = "sha256-cnOW9Ey6WdL2bAqPop5noETn12OeeKsMkWHKGmYCjJU=";
  };

  propagatedBuildInputs = [
    aiohttp
    haversine
    xmltodict
    requests
    dateparser
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_georss_client"
  ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
