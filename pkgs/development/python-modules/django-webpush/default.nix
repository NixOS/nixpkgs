{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, pythonOlder
, pythonRelaxDepsHook
, pywebpush
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-webpush";
  version = "0.3.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "safwanrahman";
    repo = "django-webpush";
    rev = "refs/tags/${version}";
    hash = "sha256-Mwp53apdPpBcn7VfDbyDlvLAVAG65UUBhT0w9OKjKbU=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
    pywebpush
  ];

  # nothing to test
  doCheck = false;

  pythonImportsCheck = [
    "webpush"
  ];

  meta = with lib; {
    description = "A Package made for integrating and sending Web Push Notification in Django Application";
    homepage = "https://github.com/safwanrahman/django-webpush/";
    changelog = "https://github.com/safwanrahman/django-webpush/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ derdennisop ];
  };
}
