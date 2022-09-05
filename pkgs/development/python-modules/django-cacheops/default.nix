{ buildPythonPackage
, fetchPypi
, lib
, django
, funcy
, redis
, six
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-toTvOf1DQYnTy7fYVBfNlyr2NSiaAyRHmCRztKifcn0=";
  };

  propagatedBuildInputs = [
    django
    funcy
    redis
    six
  ];

  checkInputs = [
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

  DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    description = "A slick ORM cache with automatic granular event-driven invalidation for Django";
    homepage = "https://github.com/Suor/django-cacheops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
