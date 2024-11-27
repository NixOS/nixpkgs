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
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Opus10";
    repo = "django-pglock";
    rev = "refs/tags/${version}";
    hash = "sha256-KCB00W3sUyEERgK/DfDPl051uFkc0IRdbOJusUVs5SA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    django-pgactivity
  ];

  pythonImportsCheck = [ "pglock" ];

  meta = {
    description = "Postgres advisory locks, table locks, and blocking lock management";
    homepage = "https://github.com/Opus10/django-pglock";
    changelog = "https://github.com/Opus10/django-pglock/blob/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
