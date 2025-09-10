{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  grpc,
  protobuf,
  setuptools,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "3.31.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-build-v${version}";
    hash = "sha256-qQ+8X6I8lt4OTgbvODsbdab2dYUk0wxWsbaVT2T651U=";
  };

  sourceRoot = "${src.name}/packages/googleapis-common-protos";

  build-system = [ setuptools ];

  dependencies = [
    grpc
    protobuf
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "googleapis-common-protos-v([0-9.]+)"
    ];
  };

  # does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "google.api"
    "google.logging"
    "google.longrunning"
    "google.rpc"
    "google.type"
  ];

  meta = {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/python-api-common-protos";
    changelog = "https://github.com/googleapis/python-api-common-protos/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
