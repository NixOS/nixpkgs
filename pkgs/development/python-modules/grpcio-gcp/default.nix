{
  lib,
  buildPythonPackage,
  fetchPypi,
  grpcio,
}:

buildPythonPackage rec {
  pname = "grpcio-gcp";
  version = "0.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4pJgXv/H2jm3qHNMcZr7EuxLU2Kt01KNivrTqjqpBXw=";
  };

  propagatedBuildInputs = [ grpcio ];

  meta = with lib; {
    description = "gRPC extensions for Google Cloud Platform";
    homepage = "https://grpc.io";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
