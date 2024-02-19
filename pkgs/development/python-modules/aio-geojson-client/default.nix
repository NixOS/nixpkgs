{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, geojson
, haversine
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aio-geojson-client";
  version = "0.20";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-GASjsOCZ4lSK0+VtIuVxFNxjMCbHkUGy/KSBtGLSaXw=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    geojson
    haversine
  ];

  nativeCheckInputs = [
    aioresponses
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
