{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
}:

buildPythonPackage rec {
  pname = "ecs-logging";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "ecs-logging-python";
    tag = version;
    hash = "sha256-YI3s+KkDPd6PVQlwpau+kgEccquo7FtfNSK278Z8B9M=";
  };

  nativeBuildInputs = [ flit-core ];

  # Circular dependency elastic-apm
  doCheck = false;

  pythonImportsCheck = [ "ecs_logging" ];

  meta = {
    description = "Logging formatters for the Elastic Common Schema (ECS) in Python";
    homepage = "https://github.com/elastic/ecs-logging-python";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
