{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  mashumaro,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyrail";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tjorim";
    repo = "pyrail";
    tag = "v${version}";
    hash = "sha256-nQmlZn+F4JzZZf3xmdlwh5vDvhbnw9iTa5BGAJyl7t4=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  pythonRelaxDeps = [
    "aiohttp"
    "mashumaro"
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    mashumaro
  ]
  ++ mashumaro.optional-dependencies.orjson;

  pythonImportsCheck = [ "pyrail" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # tests connect to the internet
    "test_get_composition"
    "test_get_connections"
    "test_get_disturbances"
    "test_get_liveboard"
    "test_get_stations"
    "test_get_vehicle"
    "test_liveboard_with_date_time"
  ];

  meta = {
    changelog = "https://github.com/tjorim/pyrail/releases/tag/${src.tag}";
    description = "Async Python wrapper for the iRail API";
    homepage = "https://github.com/tjorim/pyrail";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
