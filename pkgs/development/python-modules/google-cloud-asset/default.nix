{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  google-api-core,
  google-cloud-access-context-manager,
  google-cloud-org-policy,
  google-cloud-os-config,
  google-cloud-testutils,
  grpc-google-iam-v1,
  libcst,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.31.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-build-v${version}";
    sha256 = "sha256-qQ+8X6I8lt4OTgbvODsbdab2dYUk0wxWsbaVT2T651U=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-asset";

  build-system = [ setuptools ];

  dependencies = [
    grpc-google-iam-v1
    google-api-core
    google-cloud-access-context-manager
    google-cloud-org-policy
    google-cloud-os-config
    libcst
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  optional-dependencies = {
    libcst = [ libcst ];
  };

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.asset"
    "google.cloud.asset_v1"
    "google.cloud.asset_v1p1beta1"
    "google.cloud.asset_v1p2beta1"
    "google.cloud.asset_v1p4beta1"
    "google.cloud.asset_v1p5beta1"
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "google-cloud-asset-v";
    };
  };

  meta = {
    description = "Python Client for Google Cloud Asset API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-asset";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-asset-${src.tag}/packages/google-cloud-asset/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
