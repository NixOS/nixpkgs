{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  django-pgactivity,
}:

buildPythonPackage rec {
  pname = "django-pglock";
  version = "1.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pglock";
    tag = version;
    hash = "sha256-FKAIftHNpfGzED0nkrLv3gVhfS7lyqfwZ1mEKsw/Vc8=";
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
    changelog = "https://github.com/AmbitionEng/django-pglock/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
