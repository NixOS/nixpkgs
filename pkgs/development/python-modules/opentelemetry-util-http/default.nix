{
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-instrumentation,
  opentelemetry-test-utils,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-util-http";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/util/opentelemetry-util-http";

  build-system = [ hatchling ];

  nativeCheckInputs = [
    opentelemetry-instrumentation
    opentelemetry-test-utils
    pytestCheckHook
  ];

  # https://github.com/open-telemetry/opentelemetry-python-contrib/issues/1940
  disabledTests = [
    "test_nonstandard_method"
    "test_nonstandard_method_allowed"
  ];

  pythonImportsCheck = [ "opentelemetry.util.http" ];

  __darwinAllowLocalNetworking = true;

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/util/opentelemetry-util-http";
    description = "Web util for OpenTelemetry";
  };
}
