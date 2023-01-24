{ lib
, aio-geojson-client
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-geojson-usgs-earthquakes";
  version = "0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-usgs-earthquakes";
    rev = "v${version}";
    hash = "sha256-Hb0/BdK/jjxlPl9WJJpFdOCzZpZDCguXoGreGIyN8oo=";
  };

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_usgs_earthquakes"
  ];

  meta = with lib; {
    description = "Python module for accessing the U.S. Geological Survey Earthquake Hazards Program feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
