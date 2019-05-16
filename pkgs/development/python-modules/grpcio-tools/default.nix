{ stdenv, buildPythonPackage, fetchPypi, lib, grpc, grpcio}:

buildPythonPackage rec {
  pname = "grpcio-tools";
  version = "1.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77ec4d3c92ccbbe3de37c457e3c72962e519c36cafb96abe5842bced8eb926fa";
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
