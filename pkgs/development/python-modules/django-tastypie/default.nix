{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  python-mimeparse,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-tastypie";
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-tastypie";
    repo = "django-tastypie";
    tag = "v${version}";
    hash = "sha256-KmBI8kHcmRfbNIfBEz5pHyseWcWnfP3tq6GAPi4tdhE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    python-mimeparse
  ];

  # Tests requires a Django instance
  doCheck = false;

  pythonImportsCheck = [ "tastypie" ];

  meta = {
    description = "Utilities and helpers for writing Pylint plugins";
    homepage = "https://github.com/django-tastypie/django-tastypie";
    changelog = "https://github.com/django-tastypie/django-tastypie/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
