{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "google-cloud-asset";
  version = "3.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-asset-v${version}";
    sha256 = "sha256-4Ifg9igzsVR8pWH/lcrGwCnByqYQjPKChNPJGmmQbKI=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "google-cloud-asset-v([0-9.]+)"
    ];
  };

  meta = {
    description = "Python Client for Google Cloud Asset API";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-asset";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-asset-v${version}/packages/google-cloud-asset/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
