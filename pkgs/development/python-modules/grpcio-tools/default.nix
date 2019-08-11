{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5c0fe51a155625c9d1132ab8deb56b3015e111a6961e48aeb9dd89bd7c670ab";
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
