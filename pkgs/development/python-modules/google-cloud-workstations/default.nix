{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  grpc-google-iam-v1,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-workstations";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_workstations";
    inherit version;
    hash = "sha256-/CwdmF9fSTDPXbWTq3o+ZaWvgd/F2wVB7zboSOQ7+GY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
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
    "google.cloud.workstations"
    "google.cloud.workstations_v1"
    "google.cloud.workstations_v1beta"
  ];

  meta = with lib; {
    description = "Python Client for Cloud Workstations";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-workstations";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-workstations-v${version}/packages/google-cloud-workstations/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
