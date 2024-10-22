{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  rich,
}:

buildPythonPackage rec {
  pname = "esp-idf-size";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf-size";
    rev = "v${version}";
    hash = "sha256-a01OYlHY/0ujcSW+X2GJPRQvmDWhSW9RPQS/KK4bisY=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    rich
  ];

  pythonImportsCheck = [ "esp_idf_size" ];

  meta = {
    description = "explore statically allocated RAM used by the final binary firmware image";
    homepage = "https://github.com/espressif/esp-idf-size";
    changelog = "https://github.com/espressif/esp-idf-size/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
