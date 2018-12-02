{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbc35031ec2b29af36947d085a7fbbcd8b79b84d563adf6156103d82565f78db";
  };

  # armv6l needs library to implement C++ atomics
  GRPC_PYTHON_LDFLAGS = stdenv.lib.optional (stdenv.hostPlatform.system == "armv6l-linux") "-latomic";

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
