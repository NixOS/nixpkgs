{
  buildPythonPackage,
  hatchling,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-test-utils,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  requests,
  pytest-benchmark,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) src;
  pname = "opentelemetry-propagator-aws-xray";
  version = "1.1.0.dev";
  pyproject = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/propagator/opentelemetry-propagator-aws-xray";

  build-system = [ hatchling ];

  dependencies = [ opentelemetry-api ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
