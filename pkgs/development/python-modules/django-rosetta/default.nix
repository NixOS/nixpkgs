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
<<<<<<< HEAD
  version = "0.10.3";
=======
  version = "0.10.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mbi";
    repo = "django-rosetta";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VnKbtzLY2+3RTk4gNZASuVSDGzfgoyr06RUNB2r0eDw=";
=======
    hash = "sha256-NqDrCDvvyZsce7/VWXujAStAW8UtNSro8aelrDi4EEs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Rosetta is a Django application that facilitates the translation process of your Django projects";
    homepage = "https://github.com/mbi/django-rosetta";
    changelog = "https://github.com/mbi/django-rosetta/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
=======
  meta = with lib; {
    description = "Rosetta is a Django application that facilitates the translation process of your Django projects";
    homepage = "https://github.com/mbi/django-rosetta";
    changelog = "https://github.com/mbi/django-rosetta/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ derdennisop ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
