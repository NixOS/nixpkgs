{
  lib,
  buildPythonPackage,
  poetry-core,
  fetchFromGitHub,
  pytestCheckHook,
  click,
}:

buildPythonPackage rec {
  pname = "kml2geojson";
  version = "5.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrcagney";
    repo = "kml2geojson";
    rev = version;
    hash = "sha256-iJEcXpvy+Y3MkxAF2Q1Tkcx8GxUVjeVzv6gl134zdiI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kml2geojson" ];

  meta = {
    description = "Library to convert KML to GeoJSON";
    mainProgram = "k2g";
    homepage = "https://github.com/mrcagney/kml2geojson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
