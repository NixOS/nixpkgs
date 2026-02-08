{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  protobuf,
  proto-plus,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-os-config";
  version = "1.22.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_os_config";
    inherit version;
    hash = "sha256-15oxD2+hznRwqqCExw443AXZhTH0aPghs6Um5NM6cOQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "google.cloud.osconfig" ];

  disabledTests = [
    # Test requires a project ID
    "test_patch_deployment"
    "test_patch_job"
    "test_list_patch_jobs"
  ];

  meta = {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-os-config";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-os-config-v${version}/packages/google-cloud-os-config/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
