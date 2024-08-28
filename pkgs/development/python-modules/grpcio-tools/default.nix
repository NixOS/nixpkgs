{
  lib,
  buildPythonPackage,
  fetchPypi,
  protobuf,
  grpcio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.66.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "grpcio_tools";
    inherit version;
    hash = "sha256-UFX/6EDqj1BcMDeL4Cr7Tb7LM0gOVU3r4Qtj1rL2QcM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'protobuf>=4.21.6,<5.0dev' 'protobuf'
  '';

  outputs = [
    "out"
    "dev"
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [
    protobuf
    grpcio
    setuptools
  ];

  # no tests in the package
  doCheck = false;

  pythonImportsCheck = [ "grpc_tools" ];

  meta = with lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = [ ];
  };
}
