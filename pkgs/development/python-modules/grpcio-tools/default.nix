{ lib, buildPythonPackage, fetchPypi, protobuf, grpcio, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.50.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88b75f2afd889c7c6939f58d76b58ab84de4723c7de882a1f8448af6632e256f";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'protobuf>=4.21.6,<5.0dev' 'protobuf'
  '';

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;

  propagatedBuildInputs = [ protobuf grpcio setuptools ];

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
