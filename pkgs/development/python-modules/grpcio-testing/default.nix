{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
  protobuf,
  pythonOlder,
  setuptools,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-testing";
  version = "1.70.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "grpcio_testing";
    inherit version;
    hash = "sha256-XrVNt0zgW8l+4VuzrgDt36ACuD9YBoE1cv2ceYAD4HU=";
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
