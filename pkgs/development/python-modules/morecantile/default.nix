{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  attrs,
  click,
  pydantic,
  pyproj,

  # tests
  mercantile,
  rasterio,
  pytestCheckHook,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "morecantile";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "morecantile";
    tag = version;
    hash = "sha256-RH8eO8KhxPtsD3ohOErwUpV9VFZUXlJ2fctQiUOc6L4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    attrs
    click
    pydantic
    pyproj
  ];

  nativeCheckInputs = [
    mercantile
    pytestCheckHook
    rasterio
    versionCheckHook
  ];

  pythonImportsCheck = [ "morecantile" ];

  meta = {
    description = "Construct and use map tile grids in different projection";
    homepage = "https://developmentseed.org/morecantile";
    downloadPage = "https://github.com/developmentseed/morecantile";
    changelog = "https://github.com/developmentseed/morecantile/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    mainProgram = "morecantile";
  };
}
