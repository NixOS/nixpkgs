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
  version = "0.12";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-quakes";
    rev = "v${version}";
    sha256 = "166gvcc1rzigb822k1373y18k54x5aklikr8sc7hyml5vz937xr7";
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
