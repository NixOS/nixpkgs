{
  lib,
  buildPythonPackage,
  poetry-core,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  click,
}:

buildPythonPackage rec {
  pname = "kml2geojson";
  version = "5.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mrcagney";
    repo = pname;
    rev = version;
    hash = "sha256-iJEcXpvy+Y3MkxAF2Q1Tkcx8GxUVjeVzv6gl134zdiI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "kml2geojson" ];

  meta = with lib; {
    description = "Library to convert KML to GeoJSON";
    mainProgram = "k2g";
    homepage = "https://github.com/mrcagney/kml2geojson";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
