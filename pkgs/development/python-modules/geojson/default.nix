{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
    tag = version;
    hash = "sha256-OL+7ntgzpA63ALQ8whhKRePsKxcp81PLuU1bHJvxN9U=";
  };

  patches = [
    (fetchpatch2 {
      name = "dont-fail-with-python-313.patch";
      url = "https://github.com/jazzband/geojson/commit/c13afff339e6b78f442785cc95f0eb66ddab3e7b.patch?full_index=1";
      hash = "sha256-xdz96vzTA+zblJtCvXIZe5p51xJGM5eB/HAtCXgy5JA=";
    })
  ];

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
