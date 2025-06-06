{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
  protobuf,
}:

buildPythonPackage rec {
  pname = "grpcio-channelz";
  version = "1.64.1";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_channelz";
    inherit version;
    hash = "sha256-FUNKohIyERNoZe1y5JzmaP6IausTewNgpv6765Efd1U=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "grpcio"
    "protobuf"
  ];

  dependencies = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "grpc_channelz" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Channel Level Live Debug Information Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-channelz";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
