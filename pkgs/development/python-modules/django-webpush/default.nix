{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  pywebpush,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-webpush";
  version = "0.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "safwanrahman";
    repo = "django-webpush";
    tag = version;
    hash = "sha256-Mwp53apdPpBcn7VfDbyDlvLAVAG65UUBhT0w9OKjKbU=";
  };

  pythonRelaxDeps = [ "pywebpush" ];

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    django
    pywebpush
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "webpush" ];

  meta = {
    description = "Module for integrating and sending Web Push Notification in Django Application";
    homepage = "https://github.com/safwanrahman/django-webpush/";
    changelog = "https://github.com/safwanrahman/django-webpush/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
