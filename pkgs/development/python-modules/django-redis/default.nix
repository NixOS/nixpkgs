{ lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, django
, redis
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-redis";
  version = "5.0.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-redis";
    rev = version;
    sha256 = "1np10hfyg4aamlz7vav9fy80gynb1lhl2drqkbckr3gg1gbz6crj";
  };

  postPatch = ''
    sed -i '/-cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    django
    redis
  ];

  pythonImportsCheck = [
    "django_redis"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/test_backend.py"  # django.core.exceptions.ImproperlyConfigured: Requested setting DJANGO_REDIS_SCAN_ITERSIZE, but settings are not configured.
  ];

  meta = with lib; {
    description = "Full featured redis cache backend for Django";
    homepage = "https://github.com/jazzband/django-redis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
