{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  types-psycopg2,
}:

buildPythonPackage rec {
  pname = "django-types";
  version = "0.21.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_types";
    inherit version;
    hash = "sha256-254xUgGfooJBMPBDM50sd+8Vb3fPSoqPDZGhqU/GG1k=";
  };

  build-system = [ poetry-core ];

  dependencies = [ types-psycopg2 ];

  meta = {
    description = "Type stubs for Django";
    homepage = "https://github.com/sbdchd/django-types";
    changelog = "https://github.com/sbdchd/django-types/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
