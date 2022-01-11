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
}:

buildPythonPackage rec {
  pname = "aio-geojson-client";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-client";
    rev = "v${version}";
    sha256 = "0sbzrzmny7x4bkbg6z0cjn4d10r50nxdyaq7g6lagwd8ijpkg8l3";
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

  pythonImportsCheck = [ "aio_geojson_client" ];

  meta = with lib; {
    description = "Python module for accessing GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
