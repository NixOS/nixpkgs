{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  kafka-python-ng,
  port-for,
  pytest,
}:

buildPythonPackage rec {
  pname = "pytest-kafka";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "karolinepauls";
    repo = "pytest-kafka";
    tag = "v${version}";
    hash = "sha256-OR8SpNswbPOVtAcFuZgrZJR5K6wPb1TS5leybKWr3zY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    kafka-python-ng
    port-for
    pytest
  ];

  pythonImportsCheck = [ "pytest_kafka" ];

  # Tests depends on a kafka server running
  doCheck = false;

  meta = {
    description = "Pytest fixture factories for Zookeeper, Kafka server and Kafka consumer";
    homepage = "https://gitlab.com/karolinepauls/pytest-kafka";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
