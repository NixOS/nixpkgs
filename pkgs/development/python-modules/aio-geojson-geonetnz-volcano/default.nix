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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-volcano";
  version = "0.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-volcano";
    rev = "refs/tags/v${version}";
    hash = "sha256-B+jULYeel7efk7fB26zXQyS1ZCsmFVKlOkfnKWFQFJ4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aioresponses
    mock
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_geonetnz_volcano" ];

  meta = with lib; {
    description = "Python module for accessing the GeoNet NZ Volcanic GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
