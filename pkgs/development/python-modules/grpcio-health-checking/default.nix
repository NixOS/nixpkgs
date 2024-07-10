{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  protobuf,
}:

buildPythonPackage rec {
  pname = "grpcio-health-checking";
  version = "1.64.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_health_checking";
    inherit version;
    hash = "sha256-VSOJ8/Jj32p/U8sk8opjGlhKMHIfn0Mp0nFZU+GX49s=";
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
