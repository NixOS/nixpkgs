{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "esp-idf-kconfig";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf-kconfig";
    rev = "v${version}";
    hash = "sha256-aZUSl4Q++GTxnS7/V+p1rcpdGbTAMLXBvUJ3Cmb5DJg=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "esp_idf_kconfig" ];

  meta = {
    description = "enable espressif project configuration using the kconfig language";
    homepage = "https://github.com/espressif/esp-idf-kconfig";
    changelog = "https://github.com/espressif/esp-idf-kconfig/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
