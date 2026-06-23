{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

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
  version = "1.2.1-pre2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graphite-project";
    repo = "graphite-web";
    tag = "1.2.1-pre2";
    hash = "sha256-2C5iWn5/BoX0OPT/UQO94V1oZ/xiRzgoipp0551dnpM=";
  };

  patches = [
    # https://github.com/graphite-project/graphite-web/pull/2914
    (fetchpatch {
      name = "epoch-django5-localize-via-pytz.patch";
      url = "https://github.com/graphite-project/graphite-web/commit/a2fdc9042053e0eb7a751609571dd753b3f1476b.patch";
      hash = "sha256-iYQ9B3zWQZC9uI6yysBtKmPa0qvD422rJrMIuLxknV8=";
    })
  ];

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

  build-system = [ setuptools ];

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
    # Start a redis server on a per-build port. Darwin builds share the host
    # network (no netns isolation), so concurrent builds would otherwise
    # collide on the default port 6379. test_redis_tagdb reads TEST_REDIS_PORT.
    ''
      export TEST_REDIS_PORT=$(( ($$ % 20000) + 20000 ))
      ${pkgs.valkey}/bin/redis-server --port "$TEST_REDIS_PORT" &
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
      basvandijk
    ];
  };
}
