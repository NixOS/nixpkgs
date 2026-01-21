{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-auth,
  google-cloud-testutils,
  grpcio,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-ai-generativelanguage";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "google_ai_generativelanguage";
    inherit version;
    hash = "sha256-JSR0j0E5F0Rv68jgh53A1PAmoGT4nxfEK4G+p3q3bIQ=";
  };

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
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-ai-generativelanguage-v${version}/packages/google-ai-generativelanguage/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
