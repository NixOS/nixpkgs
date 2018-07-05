{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ck6818kb4nb6skm9lqg492brqs7kfk65f4hh2c7h7c8pkbrpcw1";
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
