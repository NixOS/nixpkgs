{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3fd64a5b8c1d981f6d68a331449109633710a346051c44e0f0cca1812e2b4b0";
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
