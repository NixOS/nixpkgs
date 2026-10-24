{
  buildPythonPackage,
  opentelemetry-instrumentation,
  hatchling,
  opentelemetry-api,
  opentelemetry-semantic-conventions,
  wrapt,
  aio-pika,
  pytestCheckHook,
}:

buildPythonPackage {
  inherit (opentelemetry-instrumentation) version src;
  pname = "opentelemetry-instrumentation-aio-pika";
  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${opentelemetry-instrumentation.src.name}/instrumentation/opentelemetry-instrumentation-aio-pika";

  # Upstream hasn't released a version supporting aio-pika>=10 yet; a fix is
  # open upstream (verified working against 10.0.1 by its author) but not
  # yet merged: https://github.com/open-telemetry/opentelemetry-python-contrib/pull/4998
  pythonRelaxDeps = [ "aio_pika" ];

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
  ];

  optional-dependencies = {
    instruments = [
      aio-pika
    ];
  };

  nativeCheckInputs = [
    aio-pika
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.aio_pika" ];
  meta = opentelemetry-instrumentation.meta // {
    description = "OpenTelemetry aio-pika instrumentation";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-aio-pika";
  };
}
