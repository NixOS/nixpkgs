{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "logging-journald";
  version = "0.6.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "logging-journald";
    tag = version;
    hash = "sha256-RQ9opkAOZfhYuqOXJ2Mtnig8soL+lCveYH2YdXL1AGM=";
  };

  nativeBuildInputs = [ poetry-core ];

  # Circular dependency with aiomisc
  doCheck = false;

  pythonImportsCheck = [ "logging_journald" ];

  meta = {
    description = "Logging handler for writing logs to the journald";
    homepage = "https://github.com/mosquito/logging-journald";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
