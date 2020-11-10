{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.33.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af40774c0275f5465f49fd92bfcd9831b19b013de4cc77b8fb38aea76fa6dce3";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ protobuf grpcio setuptools ];

  # no tests in the package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
