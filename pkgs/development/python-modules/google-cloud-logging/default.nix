{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
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
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-logging";
  version = "3.16.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-logging-v${finalAttrs.version}";
    hash = "sha256-M/7uDWWz4YCfxa4gyM9BaAo10iyTMvtR2MhNpdFYnis=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-logging";

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

  # The ATOM feed loses this update most of the time due to a high update volume,
  # so query github directly.
  passthru = {
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "google-cloud-logging-v([0-9.]+)"
        "--use-github-releases"
      ];
    };
  };

  meta = {
    description = "Stackdriver Logging API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-logging";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.version}/packages/google-cloud-logging/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
