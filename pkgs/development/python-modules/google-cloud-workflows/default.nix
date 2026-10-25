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
  version = "1.24.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_workflows";
    inherit (finalAttrs) version;
    hash = "sha256-AP3XgkAq8gqoI9gargPd+JSxu3YcfZTLsqkQWaBthCI=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

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
