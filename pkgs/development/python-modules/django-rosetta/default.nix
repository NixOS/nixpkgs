{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  polib,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-rosetta";
  version = "0.10.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-rosetta";
    tag = "v${version}";
    hash = "sha256-VnKbtzLY2+3RTk4gNZASuVSDGzfgoyr06RUNB2r0eDw=";
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

  meta = with lib; {
    description = "Rosetta is a Django application that facilitates the translation process of your Django projects";
    homepage = "https://github.com/mbi/django-rosetta";
    changelog = "https://github.com/mbi/django-rosetta/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
