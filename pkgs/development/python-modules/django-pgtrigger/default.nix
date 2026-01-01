{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  psycopg2,
}:

buildPythonPackage rec {
  pname = "django-pgtrigger";
<<<<<<< HEAD
  version = "4.17.0";
=======
  version = "4.15.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pgtrigger";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-LBuqaFFHP18LPI26CcYMVO7rJsDrCBtuVKhwoTr6ACA=";
=======
    hash = "sha256-3v/YWcWZAiEH9EtxC901kEqja0TTzbNSTkjoH+cEUN4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    psycopg2
  ];

  pythonImportsCheck = [ "pgtrigger" ];

  meta = {
    description = "Write Postgres triggers for your Django models";
    homepage = "https://github.com/Opus10/django-pgtrigger";
    changelog = "https://github.com/Opus10/django-pgtrigger/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      raitobezarius
      pyrox0
    ];
  };
}
