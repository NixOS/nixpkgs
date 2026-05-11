{
  buildPythonPackage,
  hatchling,
  httpx,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-util-http,
  opentelemetry-test-utils,
  pytestCheckHook,
  respx,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-httpx";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-httpx";

  build-system = [ hatchling ];

  dependencies = [
    httpx
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.httpx" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-httpx";
    description = "Allows tracing HTTP requests made by the httpx library";
  };
}
