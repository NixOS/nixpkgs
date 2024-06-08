{
  lib,
  aio-geojson-client,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-geojson-nsw-rfs-incidents";
  version = "0.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-nsw-rfs-incidents";
    rev = "refs/tags/v${version}";
    hash = "sha256-HksiKfXhLASAgU81x7YiOXFmBLIkqJ9ldWLLY1ZbZlk=";
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
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_nsw_rfs_incidents" ];

  meta = with lib; {
    description = "Python module for accessing the NSW Rural Fire Service incidents feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-nsw-rfs-incidents";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-quakes/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
