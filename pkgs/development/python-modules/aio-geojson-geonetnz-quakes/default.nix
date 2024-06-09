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
  pname = "aio-geojson-geonetnz-quakes";
  version = "0.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-quakes";
    rev = "refs/tags/v${version}";
    hash = "sha256-8OpmA3yHjUY+N5Obri4RWeuJiW916xGSWUYUgdpmjkw=";
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

  pythonImportsCheck = [ "aio_geojson_geonetnz_quakes" ];

  meta = with lib; {
    description = "Python module for accessing the GeoNet NZ Quakes GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-geonetnz-quakes";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-quakes/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
