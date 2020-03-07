{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, futures
, gevent
, mock
, pytest
, tornado }:

buildPythonPackage rec {
  pname = "opentracing";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rcpmhy7hm6ljlm1w455il53s1amq2vii2x1wfkrcx3sj4s0dc9k";
  };

  propagatedBuildInputs = lib.optional isPy27 futures;

  checkInputs = [ gevent mock pytest tornado ];
  
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = https://github.com/opentracing/opentracing-python;
    description = "Platform API for OpenTracing";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
