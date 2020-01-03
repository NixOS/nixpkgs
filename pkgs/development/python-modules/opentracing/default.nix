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
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfd231ba5c58f90bc277787e62861eb0c6e4af76e42957bec240bbdf71fb7e0e";
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
