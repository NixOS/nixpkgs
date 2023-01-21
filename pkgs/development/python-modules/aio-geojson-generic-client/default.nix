{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, aio-geojson-client
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "aio-geojson-generic-client";
  version = "0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-generic-client";
    rev = "v${version}";
    hash = "sha256-6Gc3SRRQiISBZnCg7a+rCQHR4NQipBHmG5gWZZXIsxY=";
  };

  propagatedBuildInputs = [
    aiohttp
    aio-geojson-client
    pytz
  ];

  nativeCheckInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_generic_client"
  ];

  meta = with lib; {
    description = "Python library for accessing GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-generic-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
