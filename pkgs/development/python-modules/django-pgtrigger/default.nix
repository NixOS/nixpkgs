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
  version = "4.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pgtrigger";
    tag = version;
    hash = "sha256-LBuqaFFHP18LPI26CcYMVO7rJsDrCBtuVKhwoTr6ACA=";
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
