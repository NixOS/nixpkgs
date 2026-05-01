{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  opentelemetry-api,
  opentelemetry-sdk,
  requests,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opentelemetry-resourcedetector-gcp";
  version = "1.11.0a0";
  pyproject = true;

  # Use PyPi instead of GitHub because the GitHub tags are inaccurate
  # (GitHub tags lack the alpha suffix)
  src = fetchPypi {
    pname = "opentelemetry_resourcedetector_gcp";
    inherit (finalAttrs) version;
    hash = "sha256-kVodb9FdrKnu3T/FKw9wU3UFTy7xQOLnprTMqVpHzbE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    opentelemetry-api
    opentelemetry-sdk
    requests
    typing-extensions
  ];

  pythonImportsCheck = [
    "opentelemetry.resourcedetector.gcp_resource_detector"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # These require a 4-year-old syrupy version
    "tests/test_mapping.py"
    "tests/test_gcp_resource_detector.py"
  ];

  meta = {
    description = "Google Cloud resource detector for OpenTelemetry";
    homepage = "https://pypi.org/project/opentelemetry-resourcedetector-gcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
})
