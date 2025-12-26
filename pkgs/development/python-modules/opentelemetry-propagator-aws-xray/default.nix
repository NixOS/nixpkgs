{
  lib,
  buildPythonPackage,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  opentelemetry-instrumentation-botocore,
  opentelemetry-test-utils,
  pytestCheckHook,
  requests,
  pytest-benchmark,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-propagator-aws-xray";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/propagator/opentelemetry-propagator-aws-xray";

  build-system = [ hatchling ];

  dependencies = [ opentelemetry-api ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
    pytest-benchmark
    requests
  ];

  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [ "opentelemetry.propagators.aws" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/propagator/opentelemetry-propagator-aws-xray";
    description = "AWS X-Ray Propagator for OpenTelemetry";
  };
}
