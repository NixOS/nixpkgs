{
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  google-auth,
  grpc-google-iam-v1,
  lib,
  nix-update-script,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-artifact-registry";
  version = "1.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-artifact-registry-v${finalAttrs.version}";
    hash = "sha256-M/7uDWWz4YCfxa4gyM9BaAo10iyTMvtR2MhNpdFYnis=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-artifact-registry";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    google-auth
    grpc-google-iam-v1
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.cloud.artifactregistry"
    "google.cloud.artifactregistry_v1"
    "google.cloud.artifactregistry_v1beta2"
  ];

  passthru = {
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^google-cloud-artifact-registry: v([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Google Cloud Artifact Registry API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-artifact-registry";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-cloud-artifact-registry/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
})
