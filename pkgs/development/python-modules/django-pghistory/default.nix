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
  version = "3.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Opus10";
    repo = "django-pghistory";
    tag = version;
    hash = "sha256-YW2zcLSE3AALtyBe9KGMQpkF/HOvF90TW2ffmzj8u9o=";
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
