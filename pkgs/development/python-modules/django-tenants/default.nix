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
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-tenants";
    repo = "django-tenants";
    tag = "v${version}";
    hash = "sha256-ggMgsqLLoVhQmlsl1vhxxyMf6gk59X1xhcV7p6A3ayA=";
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
