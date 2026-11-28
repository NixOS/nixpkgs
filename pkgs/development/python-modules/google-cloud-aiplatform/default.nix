{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  certifi,
  docstring-parser,
  google-api-core,
  google-auth,
  google-cloud-bigquery,
  google-cloud-resource-manager,
  google-cloud-storage,
  google-genai,
  packaging,
  proto-plus,
  protobuf,
  pydantic,
  typing-extensions,
  pillow,
  pytest-asyncio,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "google-cloud-aiplatform";
  # LangChain's Vertex AI integration still requires the pre-2.0 SDK
  version = "1.165.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "google_cloud_aiplatform";
    inherit (finalAttrs) version;
    hash = "sha256-vWK6dZAlXKzWb50EOetzEGCvRg01u0jbvu786d/Ao1k=";
  };

  build-system = [ setuptools ];

  # Prevent this SDK's legacy namespace setup from shadowing packages
  # sharing the google python namespace
  pythonNamespaces = [ "google.cloud" ];

  pythonRelaxDeps = [ "protobuf" ];

  dependencies = [
    certifi
    docstring-parser
    google-api-core
    google-auth
    google-cloud-bigquery
    google-cloud-resource-manager
    google-cloud-storage
    google-genai
    packaging
    proto-plus
    protobuf
    pydantic
    typing-extensions
  ]
  ++ google-api-core.optional-dependencies.grpc;

  nativeCheckInputs = [
    pillow
    pytest-asyncio
    pytestCheckHook
  ];

  # other test suites need cloud and frameworks like tf, ray, pytorch
  enabledTestPaths = [ "tests/unit/vertexai/test_generative_models.py" ];

  preCheck = ''
    # don't import these source directories for testing
    rm -r google vertexai
  '';

  pythonImportsCheck = [
    "google.cloud.aiplatform"
    "vertexai.generative_models"
    "vertexai.language_models"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=(1\\..*)" ];
  };

  meta = {
    description = "Vertex AI API client library";
    homepage = "https://github.com/googleapis/python-aiplatform";
    changelog = "https://github.com/googleapis/python-aiplatform/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
