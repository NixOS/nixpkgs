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
  version = "0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-usgs-earthquakes";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q9vBy5R5N5ihJdSMALo88qVYcFVs2/33lYRPdLej4S8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    aioresponses
    pytest-asyncio
  ];

  pythonImportsCheck = [ "aio_geojson_usgs_earthquakes" ];

  meta = with lib; {
    description = "Python module for accessing the U.S. Geological Survey Earthquake Hazards Program feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes";
    changelog = "https://github.com/exxamalte/python-aio-geojson-usgs-earthquakes/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
