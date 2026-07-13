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
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aio-geojson-usgs-earthquakes";
  version = "2026.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-usgs-earthquakes";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Module for accessing the U.S. Geological Survey Earthquake Hazards Program feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes";
    changelog = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
