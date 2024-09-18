{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "geojson";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "geojson";
    rev = "refs/tags/${version}";
    hash = "sha256-OL+7ntgzpA63ALQ8whhKRePsKxcp81PLuU1bHJvxN9U=";
  };

  nativeBuildInputs = [ setuptools ];

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
