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

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "3.11.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_vision";
    inherit version;
    hash = "sha256-w8tX3yzxUuvmLrqumx1d7/Wiauxb1uHH9n5Ev29FGPQ=";
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

  meta = with lib; {
    description = "Cloud Vision API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-vision";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-vision-v${version}/packages/google-cloud-vision/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
