{
  lib,
  aio-geojson-client,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pytz,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-geojson-usgs-earthquakes";
  version = "0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-usgs-earthquakes";
    tag = "v${version}";
    hash = "sha256-UzLnctft/D38bqClqyyJ4b5GvVXM4CFSd6TypuLo0Y4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_usgs_earthquakes" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Module for accessing the U.S. Geological Survey Earthquake Hazards Program feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes";
    changelog = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
