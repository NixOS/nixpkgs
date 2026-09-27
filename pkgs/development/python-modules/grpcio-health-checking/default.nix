{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  protobuf,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-health-checking";
  version = "1.83.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_health_checking";
    inherit version;
    hash = "sha256-1gkk5vutOPNcNyd5vF62UaAORG1tJPHRxy8UKXodDlY=";
  };

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonRelaxDeps = [ "grpcio" ];

  pythonImportsCheck = [ "grpc_health" ];

  # no tests
  doCheck = false;

  meta = {
    description = "Standard Health Checking Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-health-checking/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
