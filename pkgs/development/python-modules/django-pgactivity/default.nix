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
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Opus10";
    repo = "django-pgactivity";
    tag = version;
    hash = "sha256-XJDnNMhkoaRQBVsAdDqnFjOobUHi/RaMQZJnI61MuVI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    psycopg
  ];

  pythonImportsCheck = [ "pgactivity" ];

  meta = {
    description = "View, filter, and kill Postgres queries";
    homepage = "https://github.com/Opus10/django-pgactivity";
    changelog = "https://github.com/Opus10/django-pgactivity/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
