{
  lib,
  buildPythonPackage,
  isPy27,
  fetchFromGitHub,
  django,
  redis,
  rq,
  sentry-sdk,
}:

buildPythonPackage rec {
  pname = "django-rq";
  version = "2.10.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VE4OFFpNR9txCyhs6Ye36DBWb8DNlCT1BO436KwFMY8=";
  };

  propagatedBuildInputs = [
    django
    redis
    rq
    sentry-sdk
  ];

  pythonImportsCheck = [ "django_rq" ];

  doCheck = false; # require redis-server

  meta = with lib; {
    description = "Simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    changelog = "https://github.com/rq/django-rq/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
