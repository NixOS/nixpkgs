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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "3.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_vision";
    inherit version;
    hash = "sha256-ISJqrJy0ukW/icwuEHrqGeT3j5c26x3laDfgwpif7P8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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
    homepage = "https://github.com/googleapis/python-vision";
    changelog = "https://github.com/googleapis/python-vision/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
