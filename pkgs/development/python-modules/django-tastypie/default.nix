{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  python-mimeparse,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-tastypie";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-tastypie";
    repo = "django-tastypie";
    rev = "refs/tags/v${version}";
    hash = "sha256-StXWqwGVILXtK53fa2vSNXSIf7UGfdn7iJyOIzdnth4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    python-mimeparse
  ];

  # Tests requires a Django instance
  doCheck = false;

  pythonImportsCheck = [ "tastypie" ];

  meta = with lib; {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/django-tastypie/django-tastypie";
    changelog = "https://github.com/django-tastypie/django-tastypie/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
