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

buildPythonPackage rec {
  pname = "google-cloud-netapp";
  version = "0.3.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    rev = "google-cloud-netapp-v${version}";
    hash = "sha256-ietiyPCghGUD1jlGdZMhVgVozAlyfdvYgkV6NNlzLQg=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-netapp";

  build-system = [ setuptools ];

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

  passthru.updateScript = gitUpdater {
    rev-prefix = "google-cloud-netapp-v";
  };

  meta = {
    description = "Python Client for NetApp API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-netapp";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-netapp-v${version}/packages/google-cloud-netapp/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
