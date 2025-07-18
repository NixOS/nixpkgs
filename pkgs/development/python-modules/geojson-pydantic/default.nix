{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pytestCheckHook,
  pydantic,
  shapely,
}:

buildPythonPackage rec {
  pname = "geojson-pydantic";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "geojson-pydantic";
    tag = version;
    hash = "sha256-SOo4Hs1WMUerMLMgjzUVuDkUXCuiStJ4P9iMSpUF8Uw=";
  };

  build-system = [ flit-core ];

  dependencies = [ pydantic ];

  pythonImportsCheck = [ "geojson_pydantic" ];

  nativeCheckInputs = [
    pytestCheckHook
    shapely
  ];

  meta = {
    changelog = "https://github.com/developmentseed/geojson-pydantic/blob/${src.tag}/CHANGELOG.md";
    description = "Suite of Pydantic models matching the GeoJSON specification RFC 7946";
    homepage = "https://github.com/developmentseed/geojson-pydantic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ deej-io ];
  };
}
