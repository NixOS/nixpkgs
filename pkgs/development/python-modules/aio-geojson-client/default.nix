{ lib
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, geojson
, haversine
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-geojson-client";
  version = "0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-client";
    rev = "refs/tags/v${version}";
    hash = "sha256-5GiQgtbvYeleovFbXO2vlr2XPsDIWZiElM64O+urMcY=";
  };

  patches = [
    # Remove asynctest, https://github.com/exxamalte/python-aio-geojson-client/pull/35
    (fetchpatch {
      name = "remove-asynctest.patch";
      url = "https://github.com/exxamalte/python-aio-geojson-client/commit/bf617d9898a99b026b43b28bd87bb6479f518c0a.patch";
      hash = "sha256-uomH3LCaklfGURDs8SsnvNyHkubbe+5dleLEjW+I+M4=";
    })
  ];

  propagatedBuildInputs = [
    aiohttp
    geojson
    haversine
  ];

  nativeCheckInputs = [
    aresponses
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
