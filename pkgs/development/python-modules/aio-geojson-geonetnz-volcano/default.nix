{ lib
, aio-geojson-client
, aiohttp
, aresponses
, mock
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytz
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-volcano";
  version = "0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-volcano";
    rev = "refs/tags/v${version}";
    hash = "sha256-wJVFjy6QgYb6GX9pZTylYFvCRWmD2lAFZKnodsa8Yqo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_geonetnz_volcano"
  ];

  meta = with lib; {
    description = "Python module for accessing the GeoNet NZ Volcanic GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
