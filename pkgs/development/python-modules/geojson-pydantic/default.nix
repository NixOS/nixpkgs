{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pydantic,
  shapely,
}:

buildPythonPackage (finalAttrs: {
  pname = "geojson-pydantic";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "geojson-pydantic";
    tag = finalAttrs.version;
    hash = "sha256-XNSD54gNOVY7aXuw1cO0FGG3zTtecgZaWxC9KndyV9k=";
  };

  build-system = [ hatchling ];

  dependencies = [ pydantic ];

  pythonImportsCheck = [ "geojson_pydantic" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ shapely ];

  meta = {
    changelog = "https://github.com/developmentseed/geojson-pydantic/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Suite of Pydantic models matching the GeoJSON specification RFC 7946";
    homepage = "https://github.com/developmentseed/geojson-pydantic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deej-io ];
    teams = [ lib.teams.geospatial ];
  };
})
