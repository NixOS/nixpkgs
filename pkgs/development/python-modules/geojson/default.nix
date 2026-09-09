{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "geojson";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "geojson";
    tag = finalAttrs.version;
    hash = "sha256-Gz+hiv0CxitE+upLsiln+H8TtWezpUDaPH80UM7VHTA=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "geojson" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    homepage = "https://github.com/jazzband/geojson";
    changelog = "https://github.com/jazzband/geojson/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    teams = [ lib.teams.geospatial ];
  };
})
