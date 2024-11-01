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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-kms";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_kms";
    inherit version;
    hash = "sha256-suyMBB/cl8hkW/w7S2TNFJ32JFl8dbSuS8qmIU7oSus=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    grpc-google-iam-v1
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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

  meta = with lib; {
    description = "Cloud Key Management Service (KMS) API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-kms";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-kms-v${version}/packages/google-cloud-kms/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
