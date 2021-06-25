{ lib, buildPythonPackage, fetchPypi, protobuf, grpcio, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.38.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd85f58038b92e1961f8127d79691e84e151390d35cae73c4c0cbe2042f76b77";
  };

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
