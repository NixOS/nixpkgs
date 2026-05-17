{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kml2geojson";
  version = "5.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrcagney";
    repo = "kml2geojson";
    tag = finalAttrs.version;
    hash = "sha256-50hKosd4tgTV5GUXHAdTsz4S5QFtM7FTqUHy5TGcq0c=";
  };

  build-system = [ hatchling ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kml2geojson" ];

  meta = {
    description = "Library to convert KML to GeoJSON";
    homepage = "https://github.com/mrcagney/kml2geojson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "k2g";
  };
})
