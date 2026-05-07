{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  deprecated,
  google-api-core,
  google-cloud-core,
  google-cloud-testutils,
  grpc-google-iam-v1,
  grpc-interceptor,
  opentelemetry-resourcedetector-gcp,
  proto-plus,
  protobuf,
  sqlparse,

  # optional dependencies
  libcst,
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
  google-cloud-monitoring,
  mmh3,

  # testing
  mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-spanner";
  version = "3.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-spanner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QWBl7X/cKGds617IrHKaIteOnqgwB83jgfi8j/ESUws=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    deprecated
    google-api-core
    google-cloud-core
    grpc-google-iam-v1
    grpc-interceptor
    opentelemetry-resourcedetector-gcp
    proto-plus
    protobuf
    sqlparse
  ];

  optional-dependencies = {
    libcst = [ libcst ];
    tracing = [
      opentelemetry-api
      opentelemetry-sdk
      opentelemetry-semantic-conventions
      # opentelemetry-resourcedetector-gcp # Not available in nixpkgs
      google-cloud-monitoring
      mmh3
    ];
  };

  nativeCheckInputs = [
    google-cloud-monitoring
    google-cloud-testutils
    mmh3
    mock
    opentelemetry-api
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTests = [
    # Requires credentials
    "test_list_backup"
    "test_list_database"
    "test_list_instance"
    # can't import mmh3
    "test_generate_client_hash"
    # Flaky, compares to execution time
    "test_snapshot_read_concurrent"
    # Flaky, can retry too quickly and fail
    "test_retry_helper"
    # Flaky, system speed sensitive
    "test_transaction_for_concurrent_statement_should_begin_one_transaction_with_query"
    "test_transaction_for_concurrent_statement_should_begin_one_transaction_with_read"
  ];

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_backup_api.py"
    "tests/system/test_database_api.py"
    "tests/system/test_dbapi.py"
    "tests/system/test_instance_api.py"
    "tests/system/test_session_api.py"
    "tests/system/test_streaming_chunking.py"
    "tests/system/test_table_api.py"
    "tests/unit/test_metrics.py"
    "tests/unit/test_metrics_capture.py"
    "tests/unit/test_metrics_exporter.py"
    "tests/unit/test_metrics_interceptor.py"
    "tests/unit/spanner_dbapi/test_connect.py"
    "tests/unit/spanner_dbapi/test_connection.py"
    "tests/unit/spanner_dbapi/test_cursor.py"
    "samples/samples/"
  ];

  pythonImportsCheck = [
    "google.cloud.spanner_admin_database_v1"
    "google.cloud.spanner_admin_instance_v1"
    "google.cloud.spanner_dbapi"
    "google.cloud.spanner_v1"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Cloud Spanner API client library";
    homepage = "https://github.com/googleapis/python-spanner";
    changelog = "https://github.com/googleapis/python-spanner/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
