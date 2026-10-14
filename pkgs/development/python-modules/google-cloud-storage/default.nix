{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  google-auth,
  google-cloud-core,
  google-cloud-iam,
  google-cloud-kms,
  google-cloud-testutils,
  google-crc32c,
  google-resumable-media,
  grpc-google-iam-v1,
  grpcio,
  grpcio-status,
  mock,
  opentelemetry-api,
  proto-plus,
  protobuf,
  pytestCheckHook,
  pytest-asyncio,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-storage-v${version}";
    hash = "sha256-4rmrRvYW9FOpvYY4a+vbDzQRcLXfFHGSCnv7yL6S1FM=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-storage";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    google-cloud-core
    google-crc32c
    google-resumable-media
    requests
  ];

  optional-dependencies = {
    grpc = [
      google-api-core
      grpc-google-iam-v1
      grpcio
      grpcio-status
      proto-plus
      protobuf
    ]
    ++ google-api-core.optional-dependencies.grpc;
    protobuf = [ protobuf ];
    tracing = [ opentelemetry-api ];
  };

  nativeCheckInputs = [
    google-cloud-iam
    google-cloud-kms
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  enabledTestPaths = [
    "tests/unit/"
    "tests/system/"
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
    "test_restore_bucket"
    "test_set_api_request_attr"
    "upload"
    "test_update_user_agent_when_default_clientinfo_provided"
    "test_update_user_agent_when_none_clientinfo_provided"
    "test_update_user_agent_with_existing_user_agent"
    "test_403_permission_cache_fallback"
    "test_404_on_blob_bucket_deleted"
    "test_404_on_blob_but_bucket_exists"
    "test_cache_eviction_on_bucket_404"
    "test_cache_eviction_on_bucket_delete"
    "test_cache_stampede_protection"
    "test_disable_bucket_md_env_flag"
    "test_lru_bounded_capacity_eviction"
    "test_sequential_cache_priming"
    "test_sequential_cache_priming_multi_region"
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

  meta = {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-storage";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-cloud-storage/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
