{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, redis
, pytestCheckHook
, process-tests
, withDjango ? false, django-redis
, gevent
, eventlet
}:

buildPythonPackage rec {
  pname = "python-redis-lock";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Sr0Lz0kTasrWZye/VIbdJJQHjKVeSe+mk/eUB3MZCRo=";
  };

  propagatedBuildInputs = [
    redis
  ] ++ lib.optional withDjango django-redis;

  nativeCheckInputs = [
    eventlet
    gevent
    pytestCheckHook
    process-tests
    redis
  ];

  disabledTests = [
    # https://github.com/ionelmc/python-redis-lock/issues/86
    "test_no_overlap2"
  ] ++ lib.optionals stdenv.isDarwin [
    # fail on Darwin because it defaults to multiprocessing `spawn`
    "test_reset_signalizes"
    "test_reset_all_signalizes"
  ];

  doCheck = !stdenv.isLinux;  # AttributeError: 'object' object has no attribute 'register_script'
                              # FileNotFoundError: [Errno 2] No such file or directory: 'redis-server'

  meta = with lib; {
    homepage = "https://github.com/ionelmc/python-redis-lock";
    license = licenses.bsd2;
    description = "Lock context manager implemented via redis SETNX/BLPOP";
    maintainers = with maintainers; [ ];
  };
}
