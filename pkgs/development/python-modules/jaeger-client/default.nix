{
  buildPythonPackage,
  fetchPypi,
  lib,
  opentracing,
  threadloop,
  thrift,
  tornado,
}:

buildPythonPackage rec {
  pname = "jaeger-client";
  version = "4.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MVeDbtq44sIJvS1q5hET2zb37jmeZrHcu3Fdh6tJv+A=";
  };

  propagatedBuildInputs = [
    threadloop
    thrift
    tornado
    opentracing
  ];

  # FIXME: Missing dependencies: tchannel, opentracing_instrumentation
  # opentracing_instrumentation: Requires "tornado" lower than 6. Current is 6.1.
  # https://github.com/uber-common/opentracing-python-instrumentation/pull/115
  doCheck = false;

  pythonImportsCheck = [ "jaeger_client" ];

  meta = with lib; {
    description = "Jaeger bindings for Python OpenTracing API";
    downloadPage = "https://pypi.org/project/jaeger-client/";
    homepage = "https://github.com/jaegertracing/jaeger-client-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
