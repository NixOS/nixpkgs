{
  lib,
  buildPythonPackage,
  fetchPypi,
  googleapis-common-protos,
  grpcio,
  protobuf,
  pythonOlder,
}:

# This package should be updated together with the main grpc package and other
# related python grpc packages.
# nixpkgs-update: no auto update
buildPythonPackage rec {
  pname = "grpcio-status";
  version = "1.72.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "grpcio_status";
    inherit version;
    hash = "sha256-a2fJfb4rBmhVfX5EODTR40b1J5mdVaSRu33bJBysIcs=";
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

  meta = with lib; {
    description = "GRPC Python status proto mapping";
    homepage = "https://github.com/grpc/grpc/tree/master/src/python/grpcio_status";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
