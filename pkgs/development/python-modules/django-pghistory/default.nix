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
<<<<<<< HEAD
  version = "3.9.1";
=======
  version = "3.8.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Opus10";
    repo = "django-pghistory";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-8irD4crkczaZfMvajgMQBkksJ2wdomI3kUC6T6IU1as=";
=======
    hash = "sha256-Sx2dR5l86D+2t+1DViW1PfI74zyLmgwNm81zVmZ7IH8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
