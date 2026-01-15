{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  grpcio,
}:

buildPythonPackage rec {
  pname = "chirpstack-api";
  version = "3.12.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = "chirpstack-api";
    rev = "v${version}";
    hash = "sha256-TDwvUNnGAbt10lLg6U7q+JMg7uu8TLySYqNyt/uk8UY=";
  };

  sourceRoot = "${src.name}/python/src";

  propagatedBuildInputs = [
    google-api-core
    grpcio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "chirpstack_api" ];

  meta = {
    description = "ChirpStack gRPC API message and service wrappers for Python";
    homepage = "https://github.com/brocaar/chirpstack-api";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
