{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  setuptools,

  # dependencies
  google-api-core,
  google-auth,
  grpcio,
  proto-plus,
  protobuf,
}:

buildPythonPackage rec {
  pname = "google-cloud-privilegedaccessmanager";
  version = "0.4.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-privilegedaccessmanager-v${version}";
    hash = "sha256-ywRS1BfK6s+gcU8QRem0cSnfZq4BUQ2ABNcgnOa01LI=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-privilegedaccessmanager";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpcio
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  pythonImportsCheck = [
    "google.cloud.privilegedaccessmanager"
    "google.cloud.privilegedaccessmanager_v1"
  ];

  meta = {
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-cloud-privilegedaccessmanager/CHANGELOG.md";
    description = "Google Cloud Privilegedaccessmanager API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/${src.tag}/packages/google-cloud-privilegedaccessmanager";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
}
