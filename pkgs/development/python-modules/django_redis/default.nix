{ lib
, fetchPypi
, buildPythonPackage
, mock
, django
, redis
, msgpack
}:
buildPythonPackage rec {
  pname = "django-redis";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "048f665bbe27f8ff2edebae6aa9c534ab137f1e8fa7234147ef470df3f3aa9b8";
  };

  propagatedBuildInputs = [
    django
    redis
    msgpack
  ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DJANGO_REDIS_SCAN_ITERSIZE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  pythonImportsCheck = [ "django_redis" ];

  meta = with lib; {
    description = "Full featured redis cache backend for Django";
    homepage = "https://github.com/niwibe/django-redis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
