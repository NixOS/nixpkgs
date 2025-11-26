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
  version = "2.20.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_tasks";
    inherit version;
    hash = "sha256-czz0QKJdNP4c205slG0XO9g6LCLD17LHaiRZHzwWBBI=";
  };

  build-system = [ setuptools ];

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

  meta = with lib; {
    description = "Cloud Tasks API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-tasks";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-tasks-v${version}/packages/google-cloud-tasks/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
