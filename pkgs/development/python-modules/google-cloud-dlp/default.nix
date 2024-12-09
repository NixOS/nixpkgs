{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.25.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_dlp";
    inherit version;
    hash = "sha256-6R4CSOyB+beTUPNtj8wQc7uQmMUxhyO8lebV0PDu1Lg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Tests require credentials
    "test_inspect_content"
    "test_list_dlp_jobs"
  ];

  pythonImportsCheck = [
    "google.cloud.dlp"
    "google.cloud.dlp_v2"
  ];

  meta = with lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-dlp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-dlp-v${version}/packages/google-cloud-dlp/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
