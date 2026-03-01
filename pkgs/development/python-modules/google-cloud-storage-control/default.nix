{
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  google-api-core,
  google-auth,
  grpc-google-iam-v1,
  grpcio,
  lib,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-storage-control";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-storage-control-v${finalAttrs.version}";
    hash = "sha256-dgQdfHyGHwdEaJllbz97J/xW4Y0LrpE6ad6LRdax1G4=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-storage-control";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpc-google-iam-v1
    grpcio
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  pythonImportsCheck = [
    "google.cloud.storage_control"
    "google.cloud.storage_control_v2"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  passthru = {
    # bulk updater selects wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "google-cloud-storage-control-v";
    };
  };

  meta = {
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-cloud-storage-control/CHANGELOG.md";
    description = "Google Cloud Storage Control API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-storage-control";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
