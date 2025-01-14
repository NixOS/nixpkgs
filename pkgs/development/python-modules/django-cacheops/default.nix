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
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    # package name used to be django-cacheops before version 7.1, this might be a one-time mistake
    pname = "django_cacheops";
    inherit version;
    hash = "sha256-7Aeau5aFVzIe4gjGJ0ggIxgg+YymN33alx8EmBvCq1I=";
  };

  pythonRelaxDeps = [ "funcy" ];

  propagatedBuildInputs = [
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
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${pkgs.redis}/bin/redis-server >/dev/null 2>&1 &
    REDIS_PID=$!
    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${pkgs.redis}/bin/redis-cli --scan || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
      echo "Waiting for redis to be ready"
      sleep 1
      RETRY_COUNT=$((RETRY_COUNT + 1))
    done
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
      echo "Redis failed to start after $MAX_RETRIES retries"
      exit 1
    fi
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
