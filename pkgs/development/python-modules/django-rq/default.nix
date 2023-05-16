{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, django
, redis
, rq
, sentry-sdk
}:

buildPythonPackage rec {
  pname = "django-rq";
<<<<<<< HEAD
  version = "2.8.1";
=======
  version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Rabw6FIoSg9Cj4+tRO3BmBAeo9yr8KwU5xTPFL0JkOs=";
=======
    hash = "sha256-UiV9eshlUqzmoI+04BXMFVI8pm7OYQZFa9lmIQrmlRg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    django
    redis
    rq
    sentry-sdk
  ];

  pythonImportsCheck = [
    "django_rq"
  ];

  doCheck = false; # require redis-server

  meta = with lib; {
    description = "Simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    changelog = "https://github.com/rq/django-rq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
