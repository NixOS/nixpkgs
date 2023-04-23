{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, futures ? null
, gevent
, mock
, pytestCheckHook
, tornado
, six
}:

buildPythonPackage rec {
  pname = "opentracing";
  version = "2.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a173117e6ef580d55874734d1fa7ecb6f3655160b8b8974a2a1e98e5ec9c840d";
  };

  propagatedBuildInputs = lib.optional isPy27 futures;

  nativeCheckInputs = [
    gevent
    mock
    pytestCheckHook
    six
    tornado
  ];

  meta = with lib; {
    homepage = "https://github.com/opentracing/opentracing-python";
    description = "Platform API for OpenTracing";
    license = licenses.asl20;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
