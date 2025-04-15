{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
  protobuf,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-channelz";
  version = "1.71.0";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_channelz";
    inherit version;
    hash = "sha256-L2tmHe5rQ/9284/U+heUnzhH6oLlFdbm8h9Pz+BG7PI=";
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
