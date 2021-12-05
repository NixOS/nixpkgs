{ lib, buildPythonPackage, isPy27, fetchFromGitHub, django, redis, rq
, sentry-sdk }:

buildPythonPackage rec {
  pname = "django-rq";
  version = "2.5.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ly0gixl1cPHa03h44zXT8d1/NqrEBnQS6JmuuGj5Rk4=";
  };

  propagatedBuildInputs = [ django redis rq sentry-sdk ];

  pythonImportsCheck = [ "django_rq" ];

  doCheck = false; # require redis-server

  meta = with lib; {
    description =
      "Simple app that provides django integration for RQ (Redis Queue)";
    homepage = "https://github.com/rq/django-rq";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
