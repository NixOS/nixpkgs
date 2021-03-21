{ buildPythonPackage
, fetchPypi
, lib
, django
, funcy
, redis
, six
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1YUc178whzhKH87PqN3bj1UDDu39b98SciW3W8oPmd0=";
  };

  propagatedBuildInputs = [
    django
    funcy
    redis
    six
  ];

  # tests need a redis server
  # pythonImportsCheck not possible since DJANGO_SETTINGS_MODULE needs to be set
  doCheck = false;

  meta = with lib; {
    description = "A slick ORM cache with automatic granular event-driven invalidation for Django";
    homepage = "https://github.com/Suor/django-cacheops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
