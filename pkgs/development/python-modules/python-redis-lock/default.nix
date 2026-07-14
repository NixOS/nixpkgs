{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  eventlet,
  fetchFromGitHub,
  gevent,
  pkgs,
  process-tests,
  pytestCheckHook,
  redis,
  django-redis,
}:

buildPythonPackage rec {
  pname = "python-redis-lock";
  version = "4.0.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = "python-redis-lock";
    tag = "v${version}";
    hash = "sha256-KlmVRglglvj3EuX1m2sLqd/yZeU7CjeRxSUJ/cT4ww4=";
  };

  # Fix django tests
  postPatch = ''
    substituteInPlace tests/test_project/settings.py \
      --replace-fail "USE_L10N = True" ""
  '';

  patches = [
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
    pkgs.valkey
  ]
  ++ optional-dependencies.django;

  # For Django tests
  preCheck = "export DJANGO_SETTINGS_MODULE=test_project.settings";

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # fail on Darwin because it defaults to multiprocessing `spawn`
    "test_reset_signalizes"
    "test_reset_all_signalizes"
  ];

  pythonImportsCheck = [ "redis_lock" ];

  meta = {
    changelog = "https://github.com/ionelmc/python-redis-lock/blob/v${version}/CHANGELOG.rst";
    description = "Lock context manager implemented via redis SETNX/BLPOP";
    homepage = "https://github.com/ionelmc/python-redis-lock";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
