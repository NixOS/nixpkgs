{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-container";
  version = "2.66.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_container";
    inherit (finalAttrs) version;
    hash = "sha256-wCKi7VNx4Rac4rlHRi641R1MzTAoxiHvaZQot2a+DNw=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Test requires credentials
    "test_list_clusters"
  ];

  pythonImportsCheck = [
    "google.cloud.container"
    "google.cloud.container_v1"
    "google.cloud.container_v1beta1"
  ];

  meta = {
    description = "Google Container Engine API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-container";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-container-v${finalAttrs.version}/packages/google-cloud-container/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
