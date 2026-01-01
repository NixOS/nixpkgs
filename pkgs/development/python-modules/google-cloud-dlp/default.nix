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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
<<<<<<< HEAD
  version = "3.33.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_dlp";
    inherit version;
    hash = "sha256-qRC+EY7DyImMOFIWENYvShbzM6Tesqvrdz5yD25fZ+M=";
=======
  version = "3.32.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_dlp";
    inherit version;
    hash = "sha256-lXsPTvwTd9e0+6tNRwxyD4CPTw7dVXkmPwDroR9VVTk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-dlp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-dlp-v${version}/packages/google-cloud-dlp/CHANGELOG.md";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-dlp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-dlp-v${version}/packages/google-cloud-dlp/CHANGELOG.md";
    license = licenses.asl20;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
