{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58705401328b52c46df14543baf92699e978d8d6f879920321dcb0b06fb7295d";
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
