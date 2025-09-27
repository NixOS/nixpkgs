{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  google-api-core,
  grpc-google-iam-v1,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "3.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-kms-v${version}";
    hash = "sha256-5PzidE1CWN+pt7+gcAtbuXyL/pq6cnn0MCRkBfmeUSw=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-kms";

  build-system = [ setuptools ];

  dependencies = [
    grpc-google-iam-v1
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests that need credentials
    "test_list_global_key_rings"
    # Tests require PROJECT_ID
    "test_list_ekm_connections"
  ];

  pythonImportsCheck = [
    "google.cloud.kms"
    "google.cloud.kms_v1"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "google-cloud-kms-v";
  };

  # picks the wrong tag
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-kms";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-cloud-kms/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
