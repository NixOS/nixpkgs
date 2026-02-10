{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  cairocffi,
  django,
  django-tagging,
  gunicorn,
  pyparsing,
  python-memcached,
  pytz,
  six,
  txamqp,
  urllib3,
  whisper,

  # tests
  mock,
  redis,
  rrdtool,
  writableTmpDirAsHomeHook,
  python,

  # passthru
  nixosTests,
}:

buildPythonPackage {
  pname = "graphite-web";
  version = "1.1.10-unstable-2025-02-24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = "graphite-web";
    rev = "49c28e2015d605ad9ec93524f7076dd924a4731a";
    hash = "sha256-TxsQPhnI5WhQvKKkDEYZ8xnyg/qf+N9Icej6d6A0jC0=";
  };

  postPatch = ''
    substituteInPlace webapp/graphite/settings.py \
      --replace-fail \
        "join(WEBAPP_DIR, 'content')" \
        "join('$out/webapp', 'content')"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace webapp/tests/test_dashboard.py \
      --replace-fail "test_dashboard_email" "_dont_test_dashboard_email"
    substituteInPlace webapp/tests/test_render.py \
      --replace-fail "test_render_view" "_dont_test_render_view"
  '';

  dependencies = [
    cairocffi
    django
    django-tagging
    gunicorn
    pyparsing
    python-memcached
    pytz
    six
    txamqp
    urllib3
    whisper
  ];

  pythonRelaxDeps = [
    "django"
    "django-tagging"
  ];

  env = {
    # Carbon-s default installation is /opt/graphite. This env variable ensures
    # carbon is installed as a regular Python module.
    GRAPHITE_NO_PREFIX = "True";

    REDIS_HOST = "127.0.0.1";
  };

  nativeCheckInputs = [
    mock
    redis
    rrdtool
    writableTmpDirAsHomeHook
  ];

  preCheck =
    # Start a redis server
    ''
      ${pkgs.valkey}/bin/redis-server &
      REDIS_PID=$!
    '';

  checkPhase = ''
    runHook preCheck

    pushd webapp/
    # avoid confusion with installed module
    rm -r graphite

    DJANGO_SETTINGS_MODULE=tests.settings ${python.interpreter} manage.py test
    popd

    runHook postCheck
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "graphite" ];

  passthru.tests = {
    inherit (nixosTests) graphite;
  };

  meta = {
    description = "Enterprise scalable realtime graphing";
    homepage = "http://graphiteapp.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      offline
      basvandijk
    ];
  };
}
