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
  pname = "aio-geojson-geonetnz-volcano";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-volcano";
    rev = "v${version}";
    sha256 = "sha256-2iVUHMk4ydmGmmGS6lJV5pvxJHyP9bRSeh/dOXbquE0=";
  };

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_geonetnz_volcano"
  ];

  meta = with lib; {
    description = "Python module for accessing the GeoNet NZ Volcanic GeoJSON feeds";
    homepage = "https://github.com/exxamalte/pythonaio-geojson-geonetnz-volcano";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
