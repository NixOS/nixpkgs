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
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78e161ebd96a32e28e19ec7da31f2afed9e62a79726b8b5f0ed12dd16c2e5841";
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
