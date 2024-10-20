{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, django
, django-extensions
}:

buildPythonPackage rec {
  pname = "django-organizations";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bennylope";
    repo = "django-organizations";
    rev = version;
    hash = "sha256-yCYb92YJRMaKZP9yW4xZz0LO5J7lxUsMWkAqfG8K8dc=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    django-extensions
  ];

  pythonImportsCheck = [ "organizations" ];

  meta = {
    description = "Couple: Multi-user accounts for Django projects";
    homepage = "https://github.com/bennylope/django-organizations";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
