{
  buildPythonPackage,
  requests,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  httpretty,
  mocket,
  opentelemetry-test-utils,
  pytest-benchmark,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-requests";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-requests";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    requests
  ];

  nativeCheckInputs = [
    httpretty
    mocket
    opentelemetry-test-utils
    pytest-benchmark
    pytestCheckHook
  ];

  pytestFlags = [
    "--benchmark-disable"
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.requests" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-requests";
    description = "Requests instrumentation for OpenTelemetry";
  };
}
