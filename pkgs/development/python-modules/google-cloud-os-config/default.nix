{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  protobuf,
  proto-plus,
  pytestCheckHook,
  pytest-asyncio,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-os-config";
  version = "1.17.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oKOqWVmAP14dKpbVDlcX2KSRceTqVES/UGlLsYtnWHA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

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

  meta = with lib; {
    description = "Google Cloud OS Config API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-os-config";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-os-config-v${version}/packages/google-cloud-os-config/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
