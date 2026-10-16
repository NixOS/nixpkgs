{
  lib,
  buildPythonPackage,
  click,
  fetchFromCodeberg,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kml2geojson";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromCodeberg {
    owner = "araichev";
    repo = "kml2geojson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zNvV42dRSQLZnOr65SuJIVOjOKmlF1fQZkCs7SXSokI=";
  };

  build-system = [ hatchling ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kml2geojson" ];

  meta = {
    description = "Library to convert KML to GeoJSON";
    homepage = "https://codeberg.org/araichev/kml2geojson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "k2g";
  };
})
