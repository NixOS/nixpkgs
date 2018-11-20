{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d8b23af5fbce2da18a0f34a997af5157118e9890a730e8a6016d5f7a83c1c40";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ grpc grpcio ];

  # no tests in the package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Protobuf code generator for gRPC";
    license = lib.licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
