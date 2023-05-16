<<<<<<< HEAD
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
=======
{ lib
, buildPythonPackage
, fetchPypi
, django
, funcy
, redis
, pytest-django
, pytestCheckHook
, pythonOlder
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "django-cacheops";
<<<<<<< HEAD
  version = "7.0.1";
=======
  version = "6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Ed3qh90DlWiXikCD2JyJ37hm6lWnpI+2haaPwZiotlA=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = [ "funcy" ];

=======
    hash = "sha256-zHP9ChwUeZJT/yCopFeRo8jSgCIXswHnDPoIroGeQ48=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    django
    funcy
    redis
    six
  ];

<<<<<<< HEAD
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
=======
  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  disabledTests = [
    # Tests require networking
    "test_cached_as"
    "test_invalidation_signal"
    "test_queryset"
    "test_queryset_empty"
    "test_lock"
    "test_context_manager"
    "test_decorator"
    "test_in_transaction"
    "test_nested"
    "test_unhashable_args"
    "test_db_agnostic_by_default"
    "test_db_agnostic_disabled"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "A slick ORM cache with automatic granular event-driven invalidation for Django";
    homepage = "https://github.com/Suor/django-cacheops";
    changelog = "https://github.com/Suor/django-cacheops/blob/${version}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
