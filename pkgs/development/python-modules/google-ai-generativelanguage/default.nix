{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  grpcio,
  grpcio-status,
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
    grpcio
    grpcio-status
    proto-plus
    protobuf
  ];

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

  meta = with lib; {
    description = "Google Ai Generativelanguage API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-ai-generativelanguage";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-ai-generativelanguage-v${version}/packages/google-ai-generativelanguage/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
