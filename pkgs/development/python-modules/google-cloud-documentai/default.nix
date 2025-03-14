{
  lib,
  buildPythonPackage,
  fetchPypi,
  google-api-core,
  google-cloud-testutils,
  mock,
  proto-plus,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-cloud-documentai";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "google_cloud_documentai";
    inherit version;
    hash = "sha256-exVhde/pnMT6r8gb7v5KeGf9VLgnulykDH6PfZzUtSU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    # https://github.com/googleapis/google-cloud-python/blob/google-cloud-documentai-v3.1.0/packages/google-cloud-documentai/setup.py
    google-api-core
    proto-plus
    protobuf
  ] ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    # https://github.com/googleapis/google-cloud-python/tree/google-cloud-documentai-v3.1.0/packages/google-cloud-documentai/docs
    "google.cloud.documentai"
    "google.cloud.documentai_v1"
    "google.cloud.documentai_v1beta3"
  ];

  meta = {
    description = "Google Cloud DocumentAI API client library";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/main/packages/google-cloud-documentai";
    changelog = "https://github.com/googleapis/google-cloud-python/blob/google-cloud-documentai-v${version}/packages/google-cloud-documentai/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ AdrienLemaire ];
  };
}
