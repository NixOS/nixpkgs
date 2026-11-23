{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  polib,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-rosetta";
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-rosetta";
    tag = "v${version}";
    hash = "sha256-kR3nwrNYOTbQmyemYU3GMYNBYuqPaJ3ZyxdNo8I8fOM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    polib
    requests
  ];

  # require internet connection
  doCheck = false;

  pythonImportsCheck = [ "rosetta" ];

  meta = {
    description = "Rosetta is a Django application that facilitates the translation process of your Django projects";
    homepage = "https://github.com/mbi/django-rosetta";
    changelog = "https://github.com/mbi/django-rosetta/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
