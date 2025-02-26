{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
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
  pname = "google-cloud-network-connectivity";
  version = "2.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "google_cloud_network_connectivity";
    hash = "sha256-caOyIo4FKGQgpa0x7lKzrsaL5nrqqg8Q1iGITY3foME=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.networkconnectivity"
    "google.cloud.networkconnectivity_v1"
  ];

  meta = with lib; {
    description = "API Client library for Google Cloud Network Connectivity Center";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-network-connectivity";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-network-connectivity-v${version}/packages/google-cloud-network-connectivity/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ aksiksi ];
  };
}
