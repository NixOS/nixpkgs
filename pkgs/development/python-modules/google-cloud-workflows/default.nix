{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-workflows";
  version = "1.20.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_workflows";
    inherit (finalAttrs) version;
    hash = "sha256-aicI4O1m3L3gtnZ3eslGSKsFKyVTnWyr0SjNJdWxcfQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.workflows"
    "google.cloud.workflows_v1"
    "google.cloud.workflows_v1beta"
  ];

  meta = {
    description = "Python Client for Cloud Workflows";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-workflows";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-workflows-v${finalAttrs.version}/packages/google-cloud-workflows/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
