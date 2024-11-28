{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ecs-logging";
  version = "2.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "ecs-logging-python";
    rev = "refs/tags/${version}";
    hash = "sha256-djCEutZqcyRfRme+omiwl3ofBUBli71TnfVu59i7vlE=";
  };

  nativeBuildInputs = [ flit-core ];

  # Circular dependency elastic-apm
  doCheck = false;

  pythonImportsCheck = [ "ecs_logging" ];

  meta = with lib; {
    description = "Logging formatters for the Elastic Common Schema (ECS) in Python";
    homepage = "https://github.com/elastic/ecs-logging-python";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
