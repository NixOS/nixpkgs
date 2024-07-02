{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  protobuf,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpcio-testing";
  version = "1.64.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "grpcio_testing";
    inherit version;
    hash = "sha256-Nta9aurAzEg/iUlYE35Jz7uQ+syH4NMnHNuMGq7XEBw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"grpcio>={version}".format(version=grpc_version.VERSION)' '"grpcio"'
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "grpc_testing" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Testing utilities for gRPC Python";
    homepage = "https://grpc.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
