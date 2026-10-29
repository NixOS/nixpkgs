{
  buildPythonPackage,
  opentelemetry-instrumentation,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-api,
  opentelemetry-sdk,

  # tests
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opentelemetry-distro";
  inherit (opentelemetry-instrumentation) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/opentelemetry-distro";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-sdk
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.distro" ];

  passthru.updateScript = opentelemetry-api.updateScript;

  meta = opentelemetry-instrumentation.meta // {
    description = "OpenTelemetry Python Distro";
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-distro";
  };
})
