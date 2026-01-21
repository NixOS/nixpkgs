{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  psycopg,
}:

buildPythonPackage rec {
  pname = "django-pgactivity";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AmbitionEng";
    repo = "django-pgactivity";
    tag = version;
    hash = "sha256-e+PodpFsGxx4SE6zQD2qVDAXx44xeIdsBO7YsdbSjiU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    psycopg
  ];

  pythonImportsCheck = [ "pgactivity" ];

  meta = {
    description = "View, filter, and kill Postgres queries";
    homepage = "https://github.com/AmbitionEng/django-pgactivity";
    changelog = "https://github.com/AmbitionEng/django-pgactivity/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
