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
  version = "2.7.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MUIwgG8GKL+V5GgiC7gZXn5tlSVrmTj/IFiP+hVB7Ks=";
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
