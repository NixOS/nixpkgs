{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  types-psycopg2,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-types";
  version = "0.24.0";
  pyproject = true;

  src = fetchPypi {
    pname = "django_types";
    inherit (finalAttrs) version;
    hash = "sha256-r5A96Lnuljt1lEWaeiDLjqqrF2risyROyqCJ4MVwsNE=";
  };

  build-system = [ hatchling ];

  dependencies = [ types-psycopg2 ];

  meta = {
    description = "Type stubs for Django";
    homepage = "https://github.com/sbdchd/django-types";
    changelog = "https://github.com/sbdchd/django-types/blob/main/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
