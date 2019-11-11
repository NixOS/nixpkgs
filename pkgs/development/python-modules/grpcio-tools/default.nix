{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.25.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "988014c714ca654b3b7ca9f4dabfe487b00e023bfdd9eaf1bb0fed82bf8c4255";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ protobuf grpcio ];

  # no tests in the package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
