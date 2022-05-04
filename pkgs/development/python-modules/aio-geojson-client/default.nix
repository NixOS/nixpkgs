{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, geojson
, haversine
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-geojson-client";
  version = "0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-client";
    rev = "v${version}";
    hash = "sha256-5GiQgtbvYeleovFbXO2vlr2XPsDIWZiElM64O+urMcY=";
  };

  propagatedBuildInputs = [
    aiohttp
    geojson
    haversine
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_client"
  ];

  meta = with lib; {
    description = "Python module for accessing GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
