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
  version = "3.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-5X3Fnud33SuC2dbM1dpSQRDF5s45AHk7/DVsQwzOmjg=";
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
