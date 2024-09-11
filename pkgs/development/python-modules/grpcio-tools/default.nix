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
  version = "1.62.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fHE2AVw9YsPu9JPvq6+eM4Dj5m0k7o6UwBy3E3f1eDM=";
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
    maintainers = with maintainers; [ ];
  };
}
