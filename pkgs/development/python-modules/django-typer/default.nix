{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  typer,
}:

buildPythonPackage rec {
  pname = "django-typer";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-CULobWIZu3txvpjVHE78leTPUHyPxiSfoWRJbemif1A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    typer
  ];

  pythonImportsCheck = [ "django_typer" ];

  meta = {
    description = "Define Django management commands with Typer";
    homepage = "https://django-typer.readthedocs.io";
    changelog = "https://django-typer.readthedocs.io/en/stable/changelog.html";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
