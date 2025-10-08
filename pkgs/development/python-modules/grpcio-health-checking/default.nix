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
  version = "1.75.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_health_checking";
    inherit version;
    hash = "sha256-TeXrJwlihA9g4Ynr3b/P4jK17Pz2GN1TQRam9mhLQL8=";
  };

  propagatedBuildInputs = [
    grpcio
    protobuf
  ];

  pythonRelaxDeps = [ "grpcio" ];

  pythonImportsCheck = [ "grpc_health" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Standard Health Checking Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-health-checking/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
