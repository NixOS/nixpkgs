{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ecs-logging";
  version = "1.1.0";
  format = "flit";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "ecs-logging-python";
    rev = version;
    sha256 = "sha256-UcQh/+K2d4tiMZaz4IAZ2w/B88vEkHoq2LCPMNZ95Mo=";
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
