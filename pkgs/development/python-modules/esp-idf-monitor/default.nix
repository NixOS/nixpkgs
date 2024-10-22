{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  esp-coredump,
  esp-idf-panic-decoder,
  pyserial,
}:

buildPythonPackage rec {
  pname = "esp-idf-monitor";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf-monitor";
    rev = "v${version}";
    hash = "sha256-TMs0X9//UCIgb+tZ0pPIcWFFjse40DL1Dghbu4Am4aM=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    esp-coredump
    esp-idf-panic-decoder
    pyserial
  ];

  pythonImportsCheck = [ "esp_idf_monitor" ];

  meta = {
    description = "serial communication input and output in ESP-IDF projects";
    homepage = "https://github.com/espressif/esp-idf-monitor";
    changelog = "https://github.com/espressif/esp-idf-monitor/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
