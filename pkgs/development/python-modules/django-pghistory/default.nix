{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  django,
  django-pgtrigger,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "django-pghistory";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Opus10";
    repo = "django-pghistory";
    tag = version;
    hash = "sha256-z1dpd2JC/IOLE/v0taJiEK8dlZedBS63KeYhv5MG6tk=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    django
    django-pgtrigger
  ];

  pythonImportsCheck = [ "pghistory" ];

  meta = {
    changelog = "https://github.com/Opus10/django-pghistory/releases/tag/${src.tag}";
    description = "History tracking for Django and Postgres";
    homepage = "https://django-pghistory.readthedocs.io";
    maintainers = with lib.maintainers; [ pyrox0 ];
    license = lib.licenses.bsd3;
  };
}
