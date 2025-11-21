{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  django,
  click,
  typer-slim,
  shellingham,
  typing-extensions,

  # optional-dependencies
  rich,

  # tests
  pytest,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-typer";
  version = "3.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W5mR5YiLWwpLkZxkXvF6QWVynIlwxCzEu7lzWgN53e0=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  dependencies = [
    django
    click
    typer-slim
    shellingham
    typing-extensions
  ];

  optional-dependencies = {
    rich = [
      rich
    ];
  };

  nativeCheckInputs = [
    pytest
    pytest-django
  ];

  pythonImportsCheck = [
    "django_typer"
  ];

  meta = with lib; {
    description = "Use Typer to define the CLI for your Django management commands.";
    homepage = "https://django-typer.readthedocs.io";
    license = licenses.mit;
    maintainers = [ ];
  };
}
