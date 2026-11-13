{
  lib,
  buildPythonPackage,
  fetchPypi,
  googleapis-common-protos,
  grpcio,
  protobuf,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-status";
  version = "1.84.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_status";
    inherit version;
    hash = "sha256-aQ7PR2yC1tmHA6gFeMwOxtC1IiGH94O9AVir0oOWy0I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'protobuf>=4.21.6' 'protobuf'
  '';

  propagatedBuildInputs = [
    googleapis-common-protos
    grpcio
    protobuf
  ];

  # Project thas no tests
  doCheck = false;

  pythonImportsCheck = [ "grpc_status" ];

  meta = {
    description = "GRPC Python status proto mapping";
    homepage = "https://github.com/grpc/grpc/tree/master/src/python/grpcio_status";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
