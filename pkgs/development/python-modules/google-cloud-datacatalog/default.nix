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

buildPythonPackage rec {
  pname = "google-cloud-datacatalog";
  version = "3.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-datacatalog-v${version}";
    hash = "sha256-4Ifg9igzsVR8pWH/lcrGwCnByqYQjPKChNPJGmmQbKI=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-datacatalog";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    grpc-google-iam-v1
    libcst
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "google.cloud.datacatalog" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "google-cloud-datacatalog-v([0-9.]+)"
    ];
  };

  meta = {
    description = "Google Cloud Data Catalog API API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-datacatalog";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-datacatalog-v${version}/packages/google-cloud-datacatalog/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
