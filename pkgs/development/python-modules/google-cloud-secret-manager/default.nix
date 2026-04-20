{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  grpc-google-iam-v1,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-secret-manager";
  version = "2.27.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_secret_manager";
    inherit version;
    hash = "sha256-avhkwlK9PBHbe7ArgMsLFKjJoz/H7E1vJF8z2M4ffNE=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.secretmanager"
    "google.cloud.secretmanager_v1"
    "google.cloud.secretmanager_v1beta1"
  ];

  meta = {
    description = "Secret Manager API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-secret-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-secret-manager-v${version}/packages/google-cloud-secret-manager/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
}
