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
  version = "1.70.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    rev = "googleapis-common-protos-v${version}";
    hash = "sha256-E1LISOLQcXqUMTTPLR+lwkR6gF1fuGGB44j38cIK/Z4=";
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
    changelog = "https://github.com/googleapis/python-api-common-protos/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
