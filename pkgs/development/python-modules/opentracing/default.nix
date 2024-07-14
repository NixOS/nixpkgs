{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  isPy27,
  futures ? null,
  gevent,
  mock,
  pytestCheckHook,
  tornado,
  six,
}:

buildPythonPackage rec {
  pname = "opentracing";
  version = "2.4.0";
  format = "setuptools";

  # incompatible with asyncio changes in 3.11 and deprecated
  # https://github.com/opentracing/specification/issues/163
  disabled = pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oXMRfm71gNVYdHNNH6fstvNlUWC4uJdKKh6Y5eychA0=";
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
