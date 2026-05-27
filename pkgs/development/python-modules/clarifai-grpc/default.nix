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
  version = "12.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Clarifai";
    repo = "clarifai-python-grpc";
    tag = version;
    hash = "sha256-4oyVZCKtQ3B3vy4cSJfV3GSylbM5sQcygAKzIv47aq8=";
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
