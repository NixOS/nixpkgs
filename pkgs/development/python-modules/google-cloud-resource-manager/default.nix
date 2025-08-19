{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-core,
  grpc-google-iam-v1,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-resource-manager";
  version = "1.14.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_resource_manager";
    inherit version;
    hash = "sha256-li4tkExVDXusSDcmB5BP97syd+O7SjbYDMmjfijm63Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.resourcemanager"
    "google.cloud.resourcemanager_v3"
  ];

  meta = with lib; {
    description = "Google Cloud Resource Manager API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-resource-manager";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-resource-manager-v${version}/packages/google-cloud-resource-manager/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
