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

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-quakes";
  version = "0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-quakes";
    tag = "v${version}";
    hash = "sha256-RZ+wgLYMl7y3CdmlipsfZGcew1pYSMEhkyyeLqIwVwI=";
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

  pythonImportsCheck = [ "aio_geojson_geonetnz_quakes" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python module for accessing the GeoNet NZ Quakes GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-geonetnz-quakes";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-quakes/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
