{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  django-pgactivity,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-pglock";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pglock";
    tag = finalAttrs.version;
    hash = "sha256-IXP7iZmGx0Odn73Tje/UkIpEkHCLhz42kLJppgy2nuU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    django-pgactivity
  ];

  pythonImportsCheck = [ "pglock" ];

  meta = {
    description = "Postgres advisory locks, table locks, and blocking lock management";
    homepage = "https://github.com/AmbitionEng/django-pglock";
    changelog = "https://github.com/AmbitionEng/django-pglock/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
