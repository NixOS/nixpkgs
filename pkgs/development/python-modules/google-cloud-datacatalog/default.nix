{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  google-api-core,
  grpc-google-iam-v1,
  libcst,
  mock,
  nix-update-script,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-datacatalog";
  version = "3.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-datacatalog-v${finalAttrs.version}";
    hash = "sha256-dVgcnnInqjUjySL7wjxGzI33t1YZJ8e9mSsmjAJ+fBI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-cloud-datacatalog";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    libcst
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "google.cloud.datacatalog" ];

  passthru = {
    # bulk updater selects wrong tag
    skipBulkUpdate = true;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "google-cloud-datacatalog-v([0-9.]+)"
      ];
    };
  };

  meta = {
    description = "Google Cloud Data Catalog API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-datacatalog";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-cloud-datacatalog/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
})
