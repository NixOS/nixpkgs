{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, django
, funcy
, redis
, six
, pytestCheckHook
, pytest-django
, mock
, dill
, jinja2
, before-after
, pythonOlder
, nettools
, pkgs
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "7.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ed3qh90DlWiXikCD2JyJ37hm6lWnpI+2haaPwZiotlA=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
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
    description = "A slick ORM cache with automatic granular event-driven invalidation for Django";
    homepage = "https://github.com/Suor/django-cacheops";
    changelog = "https://github.com/Suor/django-cacheops/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
