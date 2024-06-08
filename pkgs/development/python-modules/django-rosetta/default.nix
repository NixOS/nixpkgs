{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  polib,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "django-rosetta";
  version = "0.9.9";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-rosetta";
    rev = "refs/tags/v${version}";
    hash = "sha256-OuKgqGYBlzQNKKAJYFhNi+LnONB/mxINMj4VBAVWjqI=";
  };

  propagatedBuildInputs = [
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
    changelog = "https://github.com/mbi/django-rosetta/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
  };
}
