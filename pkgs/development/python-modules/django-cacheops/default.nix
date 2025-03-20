{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  funcy,
  redis,
  six,
  pytestCheckHook,
  pytest-django,
  mock,
  dill,
  jinja2,
  before-after,
  pythonOlder,
  nettools,
  pkgs,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "django_cacheops";
    inherit version;
    hash = "sha256-7Aeau5aFVzIe4gjGJ0ggIxgg+YymN33alx8EmBvCq1I=";
  };

  pythonRelaxDeps = [ "funcy" ];

  build-system = [ setuptools ];

  dependencies = [
    django
    funcy
    redis
    six
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    mock
    dill
    jinja2
    before-after
    nettools
    pkgs.redis
  ];

  preCheck = ''
    redis-server &
    REDIS_PID=$!
    while ! redis-cli --scan ; do
      echo waiting for redis to be ready
      sleep 1
    done
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "Slick ORM cache with automatic granular event-driven invalidation for Django";
    homepage = "https://github.com/Suor/django-cacheops";
    changelog = "https://github.com/Suor/django-cacheops/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
