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
  google-cloud-testutils,
  mock,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-ai-generativelanguage";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-python";
    tag = "google-ai-generativelanguage-v${finalAttrs.version}";
    hash = "sha256-dVgcnnInqjUjySL7wjxGzI33t1YZJ8e9mSsmjAJ+fBI=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/google-ai-generativelanguage";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "protobuf"
  ];
  dependencies = [
    google-api-core
    google-auth
    grpcio
    proto-plus
    protobuf
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "google.ai.generativelanguage"
    "google.ai.generativelanguage_v1beta2"
  ];

  meta = {
    description = "Google Ai Generativelanguage API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-ai-generativelanguage";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/${finalAttrs.src.tag}/packages/google-ai-generativelanguage/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
