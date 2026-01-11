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
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "3.33.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_dlp";
    inherit version;
    hash = "sha256-qRC+EY7DyImMOFIWENYvShbzM6Tesqvrdz5yD25fZ+M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

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

  meta = {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-dlp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-dlp-v${version}/packages/google-cloud-dlp/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
