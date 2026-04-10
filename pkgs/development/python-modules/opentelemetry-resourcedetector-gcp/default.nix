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
  version = "1.14.0";
  pyproject = true;

  # Use PyPi instead of GitHub because the GitHub tags are inaccurate
  # (GitHub tags lack the alpha suffix)
  src = fetchPypi {
    pname = "opentelemetry_resourcedetector_gcp";
    inherit (finalAttrs) version;
    hash = "sha256-ELQYAqz4FYOKhcn+Ha4C9dJ+vBdSe3dEERHAEL6tlbw=";
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
