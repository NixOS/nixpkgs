{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "esphome-glyphsets";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "esphome-glyphsets";
    tag = "v${version}";
    hash = "sha256-Cjyw08VONBAwSa7yrSHuno2sMcuheOni6mrgfX39f5A=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [
    "esphome_glyphsets"
  ];

  meta = {
    description = "Lightweight version of glyphsets for ESPHome";
    homepage = "https://github.com/esphome/esphome-glyphsets";
    changelog = "https://github.com/esphome/esphome-glyphsets/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
