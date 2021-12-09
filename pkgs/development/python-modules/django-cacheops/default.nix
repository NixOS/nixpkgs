{ buildPythonPackage
, fetchFromGitHub
, lib
, django
, funcy
, redis
, six
}:

buildPythonPackage rec {
  pname = "django-cacheops";
  version = "6.0";

  src = fetchFromGitHub {
     owner = "Suor";
     repo = "django-cacheops";
     rev = "6.0";
     sha256 = "1gfn83dv4bmd0092mz8h24jw14fpgcfjxcc7msq9d5yvrk2id3qh";
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
