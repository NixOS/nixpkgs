{
  lib,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  pytestCheckHook,
  requests,
  pytest-benchmark,
}:

buildPythonPackage rec {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-propagator-aws-xray";
  pyproject = true;

  disabled = pythonOlder "3.8";

  sourceRoot = "${opentelemetry-instrumentation.src.name}/propagator/opentelemetry-propagator-aws-xray";

  build-system = [ hatchling ];

  dependencies = [ opentelemetry-api ];

  checkInputs = [
    pytest-benchmark
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "opentelemetry.propagators.aws" ];

  meta = opentelemetry-instrumentation.meta // {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/propagator/opentelemetry-propagator-aws-xray";
    description = "OpenTelemetry Instrumentation for Botocore";
  };
}
