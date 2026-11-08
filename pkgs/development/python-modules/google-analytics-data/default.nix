{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  google-api-core,
  google-auth,
  grpcio,
  proto-plus,
  protobuf,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-analytics-data";
  version = "0.23.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-analytics-data-v${finalAttrs.version}";
    hash = "sha256-b0FYupZU0ZNeIL9xJIqEXgg7ToRCQLjiswJ67YzX7OI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-analytics-data";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
    grpcio
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.analytics.data"
    "google.analytics.data_v1beta"
  ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
  };

  meta = {
    description = "Python Client for Google Analytics Data";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-analytics-data";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-analytics-data/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dshatz ];
  };
})
