{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "esphome-glyphsets";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome-libs";
    repo = "esphome-glyphsets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cjyw08VONBAwSa7yrSHuno2sMcuheOni6mrgfX39f5A=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "esphome_glyphsets"
  ];

  meta = {
    description = "Lightweight version of glyphsets for ESPHome";
    homepage = "https://github.com/esphome-libs/esphome-glyphsets";
    changelog = "https://github.com/esphome-libs/esphome-glyphsets/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
