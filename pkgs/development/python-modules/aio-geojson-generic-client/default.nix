{
  lib,
  aio-geojson-client,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  geojson,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aio-geojson-generic-client";
  version = "0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-generic-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-065aPocJFOTn+naedxRJ7U/b7hjrYViu2MEUsBpQ9cY=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  pythonRelaxDeps = [
    # geojson>=2.4.0,<3, but we have 3.x
    "geojson"
  ];

  propagatedBuildInputs = [
    aiohttp
    aio-geojson-client
    geojson
    pytz
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aio_geojson_generic_client" ];

  meta = with lib; {
    description = "Python library for accessing GeoJSON feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-generic-client";
    changelog = "https://github.com/exxamalte/python-aio-geojson-generic-client/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
