{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-container";
  version = "2.61.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_container";
    inherit version;
    hash = "sha256-mkkbT7ybP7bjNo8fCPo8rsXGzw8WoDh7l2YS+5CJOr8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    libcst
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
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.container"
    "google.cloud.container_v1"
    "google.cloud.container_v1beta1"
  ];

  meta = {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-container";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-container-v${version}/packages/google-cloud-container/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
