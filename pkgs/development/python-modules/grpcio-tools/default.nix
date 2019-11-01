{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.24.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5efc92721a364e049ad3a174d5b20a21009fae9db04b3e5020ed0b534d9c022f";
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
