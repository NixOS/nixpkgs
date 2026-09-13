{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pydantic,
  shapely,
}:

buildPythonPackage rec {
  pname = "geojson-pydantic";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "geojson-pydantic";
    tag = version;
    hash = "sha256-XIhlZhHcBSIPGd+fFCA3CDnEoqoYvbEVmb+VFG22m5Q=";
  };

  build-system = [ hatchling ];

  dependencies = [ pydantic ];

  pythonImportsCheck = [ "geojson_pydantic" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ shapely ];

  meta = {
    changelog = "https://github.com/developmentseed/geojson-pydantic/blob/${src.tag}/CHANGELOG.md";
    description = "Suite of Pydantic models matching the GeoJSON specification RFC 7946";
    homepage = "https://github.com/developmentseed/geojson-pydantic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deej-io ];
    teams = [ lib.teams.geospatial ];
  };
}
