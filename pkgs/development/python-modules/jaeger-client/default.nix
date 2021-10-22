{ buildPythonPackage
, fetchPypi
, lib
, opentracing
, threadloop
, thrift
, tornado
}:

buildPythonPackage rec {
  pname = "jaeger-client";
  version = "4.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3bc27ad77e035efd0899f377a15f180467fec44b2afbf5be0660cc888a2a4ac3";
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
    maintainers = with maintainers; [ superherointj ];
  };
}
