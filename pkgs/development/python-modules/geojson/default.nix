{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "geojson";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "geojson";
    tag = version;
    hash = "sha256-0p8FW9alcWCSdi66wanS/F9IgO714WIRQIXvg3f9op8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "geojson" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    homepage = "https://github.com/jazzband/geojson";
    changelog = "https://github.com/jazzband/geojson/blob/${version}/CHANGELOG.rst";
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
