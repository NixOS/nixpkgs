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
  version = "3.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-tenants";
    repo = "django-tenants";
    tag = "v${version}";
    hash = "sha256-3A4ClGinyN1t5bt441BVZncpw9Ie7b81M/5Tfsbz4kw=";
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
    changelog = "https://github.com/django-tenants/django-tenants/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
