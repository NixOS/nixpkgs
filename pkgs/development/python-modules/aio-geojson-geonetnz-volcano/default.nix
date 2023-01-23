{ lib
, aio-geojson-client
, aiohttp
, aresponses
, mock
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytest-asyncio
, pytestCheckHook
, pytz
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aio-geojson-geonetnz-volcano";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-aio-geojson-geonetnz-volcano";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-2iVUHMk4ydmGmmGS6lJV5pvxJHyP9bRSeh/dOXbquE0=";
  };

  patches = [
    # Remove asynctest, https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano/pull/18
    (fetchpatch {
      name = "remove-asynctest.patch";
      url = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano/commit/d04a488130375c78efa541fd63a5d88bd6b0fd49.patch";
      hash = "sha256-ArG8CovJckzzNebd03WeU5i/jPqy2HRVBL3ICk5nZ5Y=";
    })
  ];

  propagatedBuildInputs = [
    aio-geojson-client
    aiohttp
    pytz
  ];

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
    homepage = "https://github.com/exxamalte/pythonaio-geojson-geonetnz-volcano";
    changelog = "https://github.com/exxamalte/python-aio-geojson-geonetnz-volcano/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
