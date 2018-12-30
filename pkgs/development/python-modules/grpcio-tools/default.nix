{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h0w7jlggm8nc250wwqai7lihw8mymx9jjpkl0cdmqmwbypj72vd";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ grpcio ];

  # no tests in the package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Protobuf code generator for gRPC";
    license = lib.licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ vanschelven ];
  };
}
