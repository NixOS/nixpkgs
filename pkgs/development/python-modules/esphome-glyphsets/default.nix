{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "esphome-glyphsets";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "esphome-glyphsets";
    tag = "v${version}";
    hash = "sha256-kST2AsZRWZrVmInUNN153+FOXa/t9vbHN3hAReKQJaU=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [
    "esphome_glyphsets"
  ];

  meta = {
    description = "A lightweight version of glyphsets for ESPHome";
    homepage = "https://github.com/esphome/esphome-glyphsets";
    changelog = "https://github.com/esphome/esphome-glyphsets/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
