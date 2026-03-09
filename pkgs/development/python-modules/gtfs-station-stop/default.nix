{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiofiles,
  aiohttp,
  gtfs-realtime-bindings,
  requests,
  freezegun,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-httpserver,
  pytestCheckHook,
  python-dotenv,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "gtfs-station-stop";
  version = "0.11.7";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "bcpearce";
    repo = "gtfs-station-stop";
    tag = finalAttrs.version;
    hash = "sha256-Z9pOdLXcNGK1ng7qhzg2J7CvSoDIOczN4P5Es5F2cLs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiohttp
    gtfs-realtime-bindings
    requests
  ];

  # both are added to deps but not used
  pythonRemoveDeps = [
    "asyncio-atexit"
    "coverage-badge"
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytest-cov-stub
    pytest-httpserver
    pytestCheckHook
    python-dotenv
    syrupy
  ];

  pythonImportsCheck = [ "gtfs_station_stop" ];

  meta = {
    description = "Python library for Reformatting GTFS data for Station Arrivals";
    homepage = "https://github.com/bcpearce/gtfs-station-stop";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.stepbrobd ];
  };
})
