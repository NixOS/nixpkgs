{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-extended-makemessages";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "michalpokusa";
    repo = "django-extended-makemessages";
    tag = finalAttrs.version;
    hash = "sha256-Ev0LJJxYM0VZ4bgDRqqOMMXo/qZtz7pemw7lbcc831Q=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ];

  pythonImportsCheck = [ "django_extended_makemessages" ];

  meta = {
    description = "Extended version of Django's makemessages command";
    homepage = "https://github.com/michalpokusa/django-extended-makemessages";
    changelog = "https://github.com/michalpokusa/django-extended-makemessages/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
