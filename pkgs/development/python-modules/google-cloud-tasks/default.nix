{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  pname = "google-cloud-tasks";
  version = "2.22.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_tasks";
    inherit version;
    hash = "sha256-vJfYR/HfvxtgK2e5Kbe69XD+o13O2q2rta39+BameEE=";
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
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires credentials
    "test_list_queues"
  ];

  pythonImportsCheck = [
    "google.cloud.tasks"
    "google.cloud.tasks_v2"
    "google.cloud.tasks_v2beta2"
    "google.cloud.tasks_v2beta3"
  ];

  meta = {
    description = "Cloud Tasks API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-tasks";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-tasks-v${version}/packages/google-cloud-tasks/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
