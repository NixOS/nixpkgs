{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-auth,
  google-cloud-core,
  google-cloud-iam,
  google-cloud-kms,
  google-cloud-testutils,
  google-resumable-media,
  mock,
  protobuf,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "2.18.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_storage";
    inherit version;
    hash = "sha256-qves1wza2fJ00pMyZz/KuYcI0OH03OtaU1aq7wavTZk=";
  };

  pythonRelaxDeps = [ "google-auth" ];

  build-system = [ setuptools ];

  dependencies = [
    google-auth
    google-cloud-core
    google-resumable-media
    requests
  ];

  optional-dependencies = {
    protobuf = [ protobuf ];
  };

  nativeCheckInputs = [
    google-cloud-iam
    google-cloud-kms
    google-cloud-testutils
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # Disable tests which require credentials and network access
    "create"
    "download"
    "get"
    "post"
    "test_anonymous_client_access_to_public_bucket"
    "test_build_api_url"
    "test_ctor_mtls"
    "test_ctor_w_api_endpoint_override"
    "test_ctor_w_custom_endpoint_use_auth"
    "test_hmac_key_crud"
    "test_list_buckets"
    "test_open"
    "test_set_api_request_attr"
    "upload"
  ];

  disabledTestPaths = [
    "tests/unit/test_bucket.py"
    "tests/system/test_blob.py"
    "tests/system/test_bucket.py"
    "tests/system/test_fileio.py"
    "tests/system/test_kms_integration.py"
    "tests/unit/test_transfer_manager.py"
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google

    # requires docker and network
    rm tests/conformance/test_conformance.py
  '';

  pythonImportsCheck = [ "google.cloud.storage" ];

  meta = with lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/googleapis/python-storage";
    changelog = "https://github.com/googleapis/python-storage/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
