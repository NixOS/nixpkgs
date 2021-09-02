{ lib, fetchPypi, buildPythonPackage
, threadloop, thrift, tornado, opentracing
, mock, pycurl, pytest, pytest-cov, coverage, pytest-timeout, pytest-tornado, pytest-benchmark, pytest-localserver, flake8/*, flake8-quotes */, codecov/*, tchannel, opentracing_instrumentation */, prometheus-client
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

  checkInputs = [
    mock
    pycurl
    pytest
    pytest-cov
    coverage
    pytest-timeout
    pytest-tornado
    pytest-benchmark
    pytest-localserver
    flake8
    # flake8-quotes # Missing dependency
    codecov
    # tchannel # Missing dependency
    # opentracing_instrumentation # Missing dependency
    prometheus-client
  ];
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
