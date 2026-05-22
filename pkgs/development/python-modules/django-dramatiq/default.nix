{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  django,
  dramatiq,
}:

buildPythonPackage rec {
  pname = "django-dramatiq";
  version = "0.15.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Bogdanp";
    repo = "django_dramatiq";
    tag = "v${version}";
    hash = "sha256-yiDULHX3zkCPG+usyFkz45xuoITPfRGidvepOJ/hI5g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    dramatiq
  ];

  pythonImportsCheck = [ "django_dramatiq" ];

  meta = {
    description = "Django app that integrates with Dramatiq";
    homepage = "https://github.com/Bogdanp/django_dramatiq";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
