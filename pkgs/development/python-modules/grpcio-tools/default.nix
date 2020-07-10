{ stdenv, buildPythonPackage, fetchPypi, protobuf, grpcio }:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.29.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f681c1ebd5472b804baa391b16dc59d92b065903999566f4776bfbd010bcec9";
  };

  enableParallelBuilding = true;

  propagatedBuildInputs = [ protobuf grpcio ];

  # no tests in the package
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Protobuf code generator for gRPC";
    license = licenses.asl20;
    homepage = "https://grpc.io/grpc/python/";
    maintainers = with maintainers; [ ];
  };
}
