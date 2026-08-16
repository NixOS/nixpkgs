{
  lib,
  buildPythonPackage,
  django,
  fetchPypi,
  flask,
  google-api-core,
  google-cloud-appengine-logging,
  google-cloud-audit-log,
  google-cloud-core,
  google-cloud-testutils,
  grpc-google-iam-v1,
  mock,
  opentelemetry-api,
  pandas,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  rich,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-logging";
  version = "3.16.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_cloud_logging";
    inherit version;
    hash = "sha256-CKMHa48PckIZ1vc7KiQu9p1R6LziJhM66+QaJfI/VAA=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    google-cloud-appengine-logging
    google-cloud-audit-log
    google-cloud-core
    grpc-google-iam-v1
    opentelemetry-api
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    django
    flask
    google-cloud-testutils
    mock
    pandas
    pytestCheckHook
    pytest-asyncio
    rich
  ];

  preCheck = ''
    # Prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTests = [
    # Test requires credentials
    "test_write_log_entries"
    # No need for a second import check
    "test_namespace_package_compat"
  ];

  disabledTestPaths = [
    # Tests require credentials
    "tests/system/test_system.py"
    "tests/unit/test__gapic.py"
  ];

  pythonImportsCheck = [
    "google.cloud.logging"
    "google.cloud.logging_v2"
  ];

  meta = {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-logging";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${version}/packages/google-cloud-logging/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
