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
  django-redis,
}:

buildPythonPackage rec {
  pname = "python-redis-lock";
  version = "4.0.0";

  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sr0Lz0kTasrWZye/VIbdJJQHjKVeSe+mk/eUB3MZCRo=";
  };

  # Fix django tests
  postPatch = ''
    substituteInPlace tests/test_project/settings.py \
      --replace-fail "USE_L10N = True" ""
  '';

  patches = [
    # https://github.com/ionelmc/python-redis-lock/pull/119
    (fetchpatch {
      url = "https://github.com/ionelmc/python-redis-lock/commit/ae404b7834990b833c1f0f703ec8fbcfecd201c2.patch";
      hash = "sha256-Fo43+pCtnrEMxMdEEdo0YfJGkBlhhH0GjYNgpZeHF3U=";
    })
    ./test_signal_expiration_increase_sleep.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ redis ];

  optional-dependencies.django = [ django-redis ];

  nativeCheckInputs = [
    eventlet
    gevent
    pytestCheckHook
    process-tests
    pkgs.redis
  ] ++ optional-dependencies.django;

  # For Django tests
  preCheck = "export DJANGO_SETTINGS_MODULE=test_project.settings";

  disabledTests = lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ erictapen ];
  };
}
