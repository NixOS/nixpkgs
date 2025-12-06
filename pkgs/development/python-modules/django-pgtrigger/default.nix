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
  version = "4.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pgtrigger";
    tag = version;
    hash = "sha256-ujRejhsXVEQXL7l3u6o62ck0rLfcmbTsQzTblQqarYs=";
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
