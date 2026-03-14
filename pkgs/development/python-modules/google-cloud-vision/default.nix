{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-vision";
  version = "3.12.1";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_vision";
    inherit (finalAttrs) version;
    hash = "sha256-+ZuDr3WI0w5wi4fgn/c+Q+OASX/oLHmbnwXgPzEAJ8g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "google.cloud.vision"
    "google.cloud.vision_helpers"
    "google.cloud.vision_v1"
    "google.cloud.vision_v1p1beta1"
    "google.cloud.vision_v1p2beta1"
    "google.cloud.vision_v1p3beta1"
    "google.cloud.vision_v1p4beta1"
  ];

  disabledTests = [
    # Tests require PROJECT_ID
    "test_list_products"
  ];

  meta = {
    description = "Cloud Vision API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-vision";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-vision-v${finalAttrs.version}/packages/google-cloud-vision/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
