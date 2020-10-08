{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio, setuptools }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28547272c51e1d2d343685b9f531e85bb90ad7bd93e726ba646b5627173cbc47";
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
