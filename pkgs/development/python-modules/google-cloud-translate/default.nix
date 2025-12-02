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
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-translate";
  version = "3.23.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_translate";
    inherit version;
    hash = "sha256-KKMSMN6AoP74etT8Y+o32Sbuhln3LVW51wnpCPATlag=";
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
