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
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "morecantile";
    tag = version;
    hash = "sha256-Nj0CVL5lPbJ9lqd7v6nycNZ+2UbY+tiAD0UZcNRrkeA=";
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
  versionCheckProgramArg = "--version";

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
