{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "esphome-glyphsets";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "esphome-glyphsets";
    tag = "v${version}";
    hash = "sha256-nM8omtLIWwIY6AGVqVR2/4twmMlOj21+9cSuyXzAAXY=";
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
    maintainers = with lib.maintainers; [ hexa ];
  };
}
