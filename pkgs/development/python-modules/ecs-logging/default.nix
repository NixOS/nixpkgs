{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ecs-logging";
  version = "2.0.0";
  format = "flit";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "ecs-logging-python";
    rev = "refs/tags/${version}";
    hash = "sha256-2BfZ96D24sfjFD6l+gjp6xXbSJ0kjQD/FhHLI3bpVGM=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # Circular dependency elastic-apm
  doCheck = false;

  pythonImportsCheck = [
    "ecs_logging"
  ];

  meta = with lib; {
    description = "Logging formatters for the Elastic Common Schema (ECS) in Python";
    homepage = "https://github.com/elastic/ecs-logging-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
