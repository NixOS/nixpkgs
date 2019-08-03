{ stdenv
, buildPythonPackage
, fetchPypi
, grpcio
}:

buildPythonPackage rec {
  pname = "grpcio-gcp";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e292605effc7da39b7a8734c719afb12ec4b5362add3528d8afad3aa3aa9057c";
  };

  propagatedBuildInputs = [ grpcio ];

  meta = with stdenv.lib; {
    description = "gRPC extensions for Google Cloud Platform";
    homepage = https://grpc.io;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
