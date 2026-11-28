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

  # update
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-spanner";
  version = "3.71.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-spanner-v${finalAttrs.version}";
    hash = "sha256-vsJuqmG2/H5Lf/uGnEnkmBDBL2Mkxzk1z8gbGEpR0Eg=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-spanner";

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

  enabledTestPaths = [
    "tests/"
  ];

  disabledTestPaths = [
    # Requires credentials
    "tests/system/_async/test_database_api.py"
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
    # hangs
    "tests/mockserver_tests/test_dbapi_inline_begin.py"
    # Missing values in response, likely due to version mismatches
    "tests/mockserver_tests/test_frontend_metrics.py"
  ];

  pythonImportsCheck = [
    "google.cloud.spanner_admin_database_v1"
    "google.cloud.spanner_admin_instance_v1"
    "google.cloud.spanner_dbapi"
    "google.cloud.spanner_v1"
  ];

  __darwinAllowLocalNetworking = true;

  # The ATOM feed loses this update most of the time due to a high update volume,
  # so query github directly.
  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "google-cloud-spanner-v([0-9.]+)"
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Cloud Spanner API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-spanner";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-spanner-v${finalAttrs.version}/packages/google-cloud-spanner/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
