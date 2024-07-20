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
    sha256 = "3157836edab8e2c209bd2d6ae61113db36f7ee399e66b1dcbb715d87ab49bfe0";
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
