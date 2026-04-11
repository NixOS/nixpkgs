{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  google-api-core,
  google-auth,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-netapp";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-netapp-v${finalAttrs.version}";
    hash = "sha256-17v13PN6BxY99wPCMxEupLgPxit0ssE4fwGINL0bUME=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-netapp";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    google-auth
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.netapp"
    "google.cloud.netapp_v1"
  ];

  passthru = {
    # builkupdater selects wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "google-cloud-netapp-v";
    };
  };

  meta = {
    description = "Python Client for NetApp API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-netapp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-cloud-netapp/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
