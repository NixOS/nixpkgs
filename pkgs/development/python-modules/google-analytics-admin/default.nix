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
  pname = "google-analytics-admin";
  version = "0.30.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-analytics-admin-v${finalAttrs.version}";
    hash = "sha256-b0FYupZU0ZNeIL9xJIqEXgg7ToRCQLjiswJ67YzX7OI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-analytics-admin";

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
    "google.analytics.admin"
    "google.analytics.admin_v1beta"
  ];

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
  };

  meta = {
    description = "Python Client for Google Analytics Admin";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-analytics-admin";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-analytics-admin/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dshatz ];
  };
})
