{ lib
, aio-geojson-client
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-quakes";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-quakes";
    rev = "v${version}";
    sha256 = "sha256-M1QleYVPqLFjxBmOlNJdydxDTk0JJf+GYVtOTC3YUTA=";
  };

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_geonetnz_quakes" ];

  meta = with lib; {
    description = "Python module for accessing the GeoNet NZ Quakes GeoJSON feeds";
    homepage = "https://github.com/exxamalte/pythonaio-geojson-geonetnz-quakes";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
