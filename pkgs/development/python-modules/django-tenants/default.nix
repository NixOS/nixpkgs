{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  psycopg,
}:

buildPythonPackage rec {
  pname = "django-tenants";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-tenants";
    repo = "django-tenants";
    rev = "refs/tags/v${version}";
    hash = "sha256-QdEONKVFW/DWBjXWRTG+ahvirw9BP8M6PztUMZGZ33Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    psycopg
  ];

  pythonImportsCheck = [ "django_tenants" ];

  meta = {
    description = "Django tenants using PostgreSQL Schemas";
    homepage = "https://github.com/django-tenants/django-tenants";
    changelog = "https://github.com/django-tenants/django-tenants/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
