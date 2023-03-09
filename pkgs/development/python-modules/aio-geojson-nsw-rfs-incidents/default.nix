{ lib
, aio-geojson-client
, aiohttp
, aresponses
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pytz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-geojson-nsw-rfs-incidents";
  version = "0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-nsw-rfs-incidents";
    rev = "refs/tags/v${version}";
    hash = "sha256-pn0r5iLpNnK3xmAhq/oX90hdiHgFDuwDQqfAzkp5jmw=";
  };

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aio_geojson_nsw_rfs_incidents"
  ];

  meta = with lib; {
    description = "Python module for accessing the NSW Rural Fire Service incidents feeds";
    homepage = "https://github.com/exxamalte/python-aio-geojson-nsw-rfs-incidents";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-quakes/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
