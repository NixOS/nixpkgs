{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyelftools,
}:

buildPythonPackage rec {
  pname = "esp-idf-panic-decoder";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf-panic-decoder";
    rev = "v${version}";
    hash = "sha256-5KeYX5kNWopkLorh6rLZ4YeZYPjROJ+dQzI8tPsVUa4=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ pyelftools ];

  pythonImportsCheck = [ "esp_idf_panic_decoder" ];

  meta = {
    description = "parses ESP-IDF panic handler output (registers & stack dump)";
    homepage = "https://github.com/espressif/esp-idf-panic-decoder";
    changelog = "https://github.com/espressif/esp-idf-panic-decoder/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
