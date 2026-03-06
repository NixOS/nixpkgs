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

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-network-connectivity";
  version = "2.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "google_cloud_network_connectivity";
    hash = "sha256-Fad8oso2ulaA6Nqna7AlBe9whycHzDLyFKK9wqylfzA=";
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

  pythonImportsCheck = [
    "google.cloud.networkconnectivity"
    "google.cloud.networkconnectivity_v1"
  ];

  meta = {
    description = "API Client library for Google Cloud Network Connectivity Center";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-network-connectivity";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-network-connectivity-v${finalAttrs.version}/packages/google-cloud-network-connectivity/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aksiksi ];
  };
})
