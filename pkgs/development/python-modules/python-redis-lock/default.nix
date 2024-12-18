{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  eventlet,
  fetchPypi,
  fetchpatch,
  gevent,
  pkgs,
  process-tests,
  pytestCheckHook,
  pythonOlder,
  redis,
  withDjango ? false,
  django-redis,
}:

buildPythonPackage rec {
  pname = "python-redis-lock";
  version = "4.0.0";

  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sr0Lz0kTasrWZye/VIbdJJQHjKVeSe+mk/eUB3MZCRo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ionelmc/python-redis-lock/pull/119.diff";
      hash = "sha256-Fo43+pCtnrEMxMdEEdo0YfJGkBlhhH0GjYNgpZeHF3U=";
    })

    ./test_signal_expiration_increase_sleep.patch
  ];

  dependencies = [ redis ] ++ lib.optionals withDjango [ django-redis ];

  nativeCheckInputs = [
    eventlet
    gevent
    pytestCheckHook
    process-tests
    pkgs.redis
  ];

  disabledTests =
    [
      # https://github.com/ionelmc/python-redis-lock/issues/86
      "test_no_overlap2"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # fail on Darwin because it defaults to multiprocessing `spawn`
      "test_reset_signalizes"
      "test_reset_all_signalizes"
    ];

  pythonImportsCheck = [ "redis_lock" ];

  meta = with lib; {
    changelog = "https://github.com/ionelmc/python-redis-lock/blob/v${version}/CHANGELOG.rst";
    description = "Lock context manager implemented via redis SETNX/BLPOP";
    homepage = "https://github.com/ionelmc/python-redis-lock";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vanschelven ];
  };
}
