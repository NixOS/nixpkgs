{ lib
, buildPythonPackage
, fetchFromGitHub
, glibcLocales
, unittestCheckHook
 }:

buildPythonPackage rec {
  pname = "geojson";
  version = "3.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "geojson";
    rev = "refs/tags/${version}";
    hash = "sha256-VlP/odzRH6Eg0BMZPBQkbHL/O2cIwWTKJcL5SfZoUWQ=";
  };

  pythonImportsCheck = [
    "geojson"
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  meta = {
    homepage = "https://github.com/jazzband/geojson";
    changelog = "https://github.com/jazzband/geojson/blob/${version}/CHANGELOG.rst";
    description = "Python bindings and utilities for GeoJSON";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ oxzi ];
  };
}
