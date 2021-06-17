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
}:

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-volcano";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-volcano";
    rev = "v${version}";
    sha256 = "0x4i9gjwb2j788aw4j47bxin0d2ma3khssprq4ga3cjzx2qjwjvn";
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

  pythonImportsCheck = [ "aio_geojson_geonetnz_volcano" ];

  meta = with lib; {
    description = "Python module for accessing the GeoNet NZ Volcanic GeoJSON feeds";
    homepage = "https://github.com/exxamalte/pythonaio-geojson-geonetnz-volcano";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
