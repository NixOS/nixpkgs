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
  version = "1.73.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "googleapis-common-protos-v${version}";
    hash = "sha256-LrsmLySAOTsECwxa1NaFuyZAjar0Jbg9DHNi6uqYaxk=";
  };

  sourceRoot = "${src.name}/packages/googleapis-common-protos";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

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
