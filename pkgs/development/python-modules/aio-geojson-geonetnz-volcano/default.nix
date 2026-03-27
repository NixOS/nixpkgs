{
  lib,
  aio-geojson-client,
  aiohttp,
  aioresponses,
  mock,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-volcano";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-volcano";
    tag = "v${version}";
    hash = "sha256-B+jULYeel7efk7fB26zXQyS1ZCsmFVKlOkfnKWFQFJ4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    aioresponses
    mock
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_geonetnz_volcano" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python module for accessing the GeoNet NZ Volcanic GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
