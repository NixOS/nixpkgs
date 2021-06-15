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
  version = "0.7";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-georss-client";
    rev = "v${version}";
    sha256 = "1nhw2sf92dbizxdcil1wdmbaa3hbmsiriy8jfzpqxsliw5dc0kmh";
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

  pythonImportsCheck = [ "aio_georss_client" ];

  meta = with lib; {
    description = "Python library for accessing GeoRSS feeds";
    homepage = "https://github.com/exxamalte/python-aio-georss-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
