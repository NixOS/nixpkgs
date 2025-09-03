{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-core,
  google-cloud-testutils,
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
  pname = "google-cloud-translate";
  version = "3.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_translate";
    inherit version;
    hash = "sha256-dg8l4bl5/qalncpE/8io3HCGk8UK43o5Vo/xKExTS+I=";
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
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # prevent shadowing imports
    rm -r google
  '';

  pythonImportsCheck = [
    "google.cloud.translate"
    "google.cloud.translate_v2"
    "google.cloud.translate_v3"
    "google.cloud.translate_v3beta1"
  ];

  disabledTests = [
    # Tests require PROJECT_ID
    "test_list_glossaries"
  ];

  meta = with lib; {
    description = "Google Cloud Translation API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-translate";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-translate-v${version}/packages/google-cloud-translate/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
