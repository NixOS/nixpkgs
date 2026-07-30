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

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-videointelligence";
  version = "2.20.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_videointelligence";
    inherit (finalAttrs) version;
    hash = "sha256-5EktMzhD8EAZG0cw/1igpK6hAINQBTh5vEBY3fYtqKA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

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
    # require credentials
    "test_annotate_video"
  ];

  pythonImportsCheck = [
    "google.cloud.videointelligence"
    "google.cloud.videointelligence_v1"
    "google.cloud.videointelligence_v1beta2"
    "google.cloud.videointelligence_v1p1beta1"
    "google.cloud.videointelligence_v1p2beta1"
    "google.cloud.videointelligence_v1p3beta1"
  ];

  meta = {
    description = "Google Cloud Video Intelligence API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-videointelligence";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-videointelligence-v${finalAttrs.version}/packages/google-cloud-videointelligence/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
