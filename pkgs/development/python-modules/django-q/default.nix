{
  lib,
  stdenv,
  arrow,
  blessed,
  buildPythonPackage,
  croniter,
  django,
  django-picklefield,
  django-redis,
  fetchFromGitHub,
  future,
  pkgs,
  poetry-core,
  pytest-django,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  redis,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.9";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Koed00";
    repo = "django-q";
    rev = "refs/tags/v${version}";
    hash = "sha256-gFSrAl3QGoJEJfvTTvLQgViPPjeJ6BfvgEwgLLo+uAA=";
  };

  patches = [ ./pep-621.patch ];

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "redis"
  ];

  dependencies = [
    django-picklefield
    arrow
    blessed
    django
    future
    setuptools # for pkg_resources
  ];

  nativeCheckInputs = [
    croniter
    django-redis
    pytest-django
    pytest-mock
    pytestCheckHook
  ] ++ django-redis.optional-dependencies.hiredis;

  pythonImportsCheck = [ "django_q" ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  # don't bother with two more servers to test
  disabledTests = [
    "test_disque"
    "test_mongo"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Multiprocessing distributed task queue for Django";
    homepage = "https://django-q.readthedocs.org";
    changelog = "https://github.com/Koed00/django-q/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    # django-q is unmaintained at the moment
    # https://github.com/Koed00/django-q/issues/733
    broken = lib.versionAtLeast redis.version "5";
  };
}
