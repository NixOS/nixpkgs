{
  lib,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-api,
  opentelemetry-instrumentation,

  # optional-dependencies
  requests,
  urllib3,

  # tests
  mocket,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "opentelemetry-exporter-http-transport";
  # This package is in the same repository as `opentelemetry-api`,
  # but its version is synchronized with `opentelemetry-instrumentation` in another repository.
  inherit (opentelemetry-instrumentation) version;
  pyproject = true;
  __structuredAttrs = true;

  inherit (opentelemetry-api) src;

  sourceRoot = "${opentelemetry-api.src.name}/exporter/opentelemetry-exporter-http-transport";

  build-system = [ hatchling ];

  dependencies = [ opentelemetry-api ];

  optional-dependencies = {
    requests = [ requests ];
    urllib3 = [ urllib3 ];
  };

  pythonImportsCheck = [ "opentelemetry.exporter.http.transport" ];

  nativeCheckInputs = [
    mocket
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = opentelemetry-api.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/exporter/opentelemetry-exporter-http-transport";
    description = "Pluggable HTTP transports for OpenTelemetry exporters";
  };
})
