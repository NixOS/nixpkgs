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
  version = "3.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "django-rq";
    tag = "v${version}";
    hash = "sha256-TnOKgw52ykKcR0gHXcdYfv77js7I63PE1F3POdwJgvc=";
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
    changelog = "https://github.com/rq/django-rq/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
