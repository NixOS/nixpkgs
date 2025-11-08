{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  googleapis-common-protos,
  grpcio,
  protobuf,
  requests,
}:

buildPythonPackage rec {
  pname = "clarifai-grpc";
  version = "11.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python-grpc";
    tag = version;
    hash = "sha256-eLX5wokrLH+YqrRp6Oug82a16w0sFMUClz6tQ8dDc1Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    googleapis-common-protos
    grpcio
    protobuf
    requests
  ];

  pythonRelaxDeps = [
    "grpcio"
  ];

  # almost all tests require network access
  doCheck = false;

  pythonImportsCheck = [ "clarifai_grpc" ];

  meta = {
    description = "Clarifai gRPC API Client";
    homepage = "https://github.com/Clarifai/clarifai-python-grpc";
    changelog = "https://github.com/Clarifai/clarifai-python-grpc/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
