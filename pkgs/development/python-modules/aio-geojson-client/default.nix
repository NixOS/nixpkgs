{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, geojson
, haversine
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-geojson-client";
  version = "0.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-nvfy1XLiMjyCiQo/YuzRbDtxGmAUAiq8UJwS/SkN3oM=";
  };

  propagatedBuildInputs = [
    aiohttp
    geojson
    haversine
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_client"
  ];

  meta = with lib; {
    description = "Python module for accessing GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-client";
    changelog = "https://github.com/exxamalte/python-aio-geojson-client/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
