{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, futures ? null
, gevent
, mock
, pytest
, tornado }:

buildPythonPackage rec {
  pname = "opentracing";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a173117e6ef580d55874734d1fa7ecb6f3655160b8b8974a2a1e98e5ec9c840d";
  };

  propagatedBuildInputs = lib.optional isPy27 futures;

  checkInputs = [ gevent mock pytest tornado ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/opentracing/opentracing-python";
    description = "Platform API for OpenTracing";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
