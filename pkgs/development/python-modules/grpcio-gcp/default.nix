{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  grpcio,
}:

buildPythonPackage rec {
  pname = "grpcio-gcp";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e292605effc7da39b7a8734c719afb12ec4b5362add3528d8afad3aa3aa9057c";
  };

  build-system = [ setuptools ];

  dependencies = [ grpcio ];

  meta = {
    description = "gRPC extensions for Google Cloud Platform";
    homepage = "https://grpc.io";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
