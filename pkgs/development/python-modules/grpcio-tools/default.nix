{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ce5aa660d7884f23aac1eafa93b97a4c3e2b512edff871e91fdb6ee86ebd5ea";
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
