{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
  protobuf,
}:

buildPythonPackage rec {
  pname = "grpcio-reflection";
  version = "1.64.1";
  pyproject = true;

  src = fetchPypi {
    pname = "grpcio_reflection";
    inherit version;
    hash = "sha256-43511hl02iKjtcJgSZKqLyFjlx6jeK2Fa047YyEJ88c=";
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

  pythonImportsCheck = [ "grpc_reflection" ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Standard Protobuf Reflection Service for gRPC";
    homepage = "https://pypi.org/project/grpcio-reflection";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ happysalada ];
  };
}
