{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pyyaml,
  rich,

  # tests
  esptool,
  jsonschema,
  pytestCheckHook,
  distutils,
}:

buildPythonPackage rec {
  pname = "esp-idf-size";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf-size";
    tag = "v${version}";
    hash = "sha256-LnaS6lm2/fy9aWiV/MuRKegDAmjljQFvp+uI8FmEpdI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    rich
  ];

  doCheck = false; # requires ESP-IDF

  nativeCheckInputs = [
    distutils
    esptool
    jsonschema
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "esp_idf_size"
  ];

  meta = {
    description = "";
    homepage = "https://github.com/espressif/esp-idf-size";
    changelog = "https://github.com/espressif/esp-idf-size/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
