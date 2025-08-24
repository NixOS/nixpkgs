{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  google-api-core,
  google-auth,
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
  pname = "google-cloud-iam";
  version = "3.31.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-cloud-build-v${version}";
    hash = "sha256-qQ+8X6I8lt4OTgbvODsbdab2dYUk0wxWsbaVT2T651U=";
  };

  sourceRoot = "${src.name}/packages/google-cloud-iam";

  build-system = [ setuptools ];

  dependencies = [
    google-api-core
    google-auth
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

  disabledTestPaths = [
    # unmaintained, reference wrong import path for google.cloud.iam.v1
    "tests/unit/gapic/iam_admin_v1/test_iam.py"
  ];

  pythonImportsCheck = [
    "google.cloud.iam_credentials"
    "google.cloud.iam_credentials_v1"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "google-cloud-iam-v";
  };

  meta = {
    description = "IAM Service Account Credentials API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-iam";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${src.tag}/packages/google-cloud-iam/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      austinbutler
      sarahec
    ];
  };
}
